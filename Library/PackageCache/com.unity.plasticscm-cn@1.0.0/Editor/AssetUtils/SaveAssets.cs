using System.IO;
using System.Collections.Generic;

using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;

using Codice.Client.BaseCommands;
using Codice.Client.Common;

namespace Unity.PlasticSCM.Editor.AssetUtils
{
    internal static class SaveAssets
    {
        internal static void For(
            List<ChangeInfo> changes,
            out bool isCancelled)
        {
            SaveDirtyScenes(changes, out isCancelled);

            if (isCancelled)
                return;

            AssetDatabase.SaveAssets();
        }

        static void SaveDirtyScenes(
            List<ChangeInfo> changes,
            out bool isCancelled)
        {
            isCancelled = false;

            List<Scene> scenesToSave = new List<Scene>();

            foreach (Scene dirtyScene in GetDirtyScenes())
            {
                if (Contains(changes, dirtyScene))
                    scenesToSave.Add(dirtyScene);
            }

            if (scenesToSave.Count == 0)
                return;

            isCancelled = !EditorSceneManager.
                SaveModifiedScenesIfUserWantsTo(
                    scenesToSave.ToArray());
        }

        static List<Scene> GetDirtyScenes()
        {
            List<Scene> dirtyScenes = new List<Scene>();

            for (int i = 0; i < SceneManager.sceneCount; i++)
            {
                Scene scene = SceneManager.GetSceneAt(i);

                if (!scene.isDirty)
                    continue;

                dirtyScenes.Add(scene);
            }

            return dirtyScenes;
        }

        static bool Contains(
            List<ChangeInfo> changes,
            Scene scene)
        {
            foreach (ChangeInfo change in changes)
            {
                if (PathHelper.IsSamePath(
                        change.GetFullPath(),
                        Path.GetFullPath(scene.path)))
                    return true;
            }

            return false;
        }
    }
}
