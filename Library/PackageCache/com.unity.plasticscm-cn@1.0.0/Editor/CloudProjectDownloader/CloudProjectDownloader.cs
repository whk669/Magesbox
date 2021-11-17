using System;
using System.Collections.Generic;
using System.IO;

using Codice.CM.Common;
using Codice.LogWrapper;

using PlasticGui;
using Unity.PlasticSCM.Editor.UI;
using UnityEditor;
using UnityEngine;

namespace Unity.PlasticSCM.Editor.ProjectDownloader
{
    [InitializeOnLoad]
    internal class CloudProjectDownloader
    {
        static CloudProjectDownloader()
        {
            EditorApplication.update += RunOnce;
        }

        static void RunOnce()
        {
            EditorApplication.update -= RunOnce;
            Execute();
        }

        static void Execute()
        {
            Dictionary<string, string> args = CommandLineArguments.Build(
                Environment.GetCommandLineArgs());

            mLog.DebugFormat(
                "Processing Unity arguments: {0}",
                string.Join(" ", Environment.GetCommandLineArgs()));

            string projectPath = ParseArguments.ProjectPath(args);
            string cloudRepository = ParseArguments.CloudProject(args);
            string cloudOrganization = ParseArguments.CloudOrganization(args);

            if (string.IsNullOrEmpty(projectPath) ||
                string.IsNullOrEmpty(cloudRepository) ||
                string.IsNullOrEmpty(cloudOrganization))
                return;

            PlasticApp.Initialize();

            DownloadRepositoryOperation downloadOperation = new DownloadRepositoryOperation();

            downloadOperation.DownloadRepositoryToPathIfNeeded(
                cloudRepository,
                cloudOrganization,
                Path.GetFullPath(projectPath));
        }

        static readonly ILog mLog = LogManager.GetLogger("ProjectDownloader");
    }
}
