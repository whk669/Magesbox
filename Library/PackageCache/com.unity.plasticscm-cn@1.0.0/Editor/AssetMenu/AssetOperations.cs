using System.IO;

using UnityEditor;
using UnityEditor.VersionControl;

using Codice.Client.Commands;
using Codice.Client.Commands.WkTree;
using Codice.Client.Common;
using Codice.Client.Common.Threading;
using Codice.CM.Common;
using GluonGui;
using PlasticGui;
using PlasticGui.WorkspaceWindow;
using PlasticGui.WorkspaceWindow.Diff;
using PlasticGui.WorkspaceWindow.Items;
using Unity.PlasticSCM.Editor.AssetUtils;
using Unity.PlasticSCM.Editor.UI;

using GluonCheckoutOperation = GluonGui.WorkspaceWindow.Views.WorkspaceExplorer.Explorer.Operations.CheckoutOperation;

namespace Unity.PlasticSCM.Editor.AssetMenu
{
    internal class AssetOperations : IAssetMenuOperations
    {
        internal AssetOperations(
            WorkspaceInfo wkInfo,
            IWorkspaceWindow workspaceWindow,
            IViewSwitcher viewSwitcher,
            IHistoryViewLauncher historyViewLauncher,
            ViewHost viewHost,
            NewIncomingChangesUpdater newIncomingChangesUpdater,
            EditorWindow parentWindow,
            bool isGluonMode)
        {
            mWkInfo = wkInfo;
            mWorkspaceWindow = workspaceWindow;
            mViewSwitcher = viewSwitcher;
            mHistoryViewLauncher = historyViewLauncher;
            mViewHost = viewHost;
            mNewIncomingChangesUpdater = newIncomingChangesUpdater;
            mIsGluonMode = isGluonMode;

            mGuiMessage = new UnityPlasticGuiMessage(parentWindow);
            mProgressControls = new EditorProgressControls(mGuiMessage);

        }
        void IAssetMenuOperations.ShowPendingChanges()
        {
            mViewSwitcher.ShowPendingChanges();
        }

        void IAssetMenuOperations.Checkout()
        {
            if (mIsGluonMode)
            {
                GluonCheckoutOperation.Checkout(
                    mViewHost,
                    mProgressControls,
                    mGuiMessage,
                    AssetsSelection.GetSelectedPathsWithMeta().ToArray(),
                    false,
                    RefreshAsset.VersionControlCache);
                return;
            }

            CheckoutOperation.Checkout(
                mWorkspaceWindow,
                null,
                mProgressControls,
                AssetsSelection.GetSelectedPathsWithMeta(),
                mNewIncomingChangesUpdater,
                RefreshAsset.VersionControlCache);
        }

        void IAssetMenuOperations.ShowDiff()
        {
            string selectedPath = AssetsSelection.GetSelectedPath();

            DiffInfo diffInfo = null;

            IThreadWaiter waiter = ThreadWaiter.GetWaiter(10);
            waiter.Execute(
                /*threadOperationDelegate*/ delegate
                {
                    string symbolicName = GetSymbolicName(selectedPath);
                    string extension = Path.GetExtension(selectedPath);

                    diffInfo = Plastic.API.BuildDiffInfoForDiffWithPrevious(
                        selectedPath, symbolicName, selectedPath, extension, mWkInfo);
                },
                /*afterOperationDelegate*/ delegate
                {
                    if (waiter.Exception != null)
                    {
                        ExceptionsHandler.DisplayException(waiter.Exception);
                        return;
                    }

                    DiffOperation.DiffWithPrevious(
                        diffInfo,
                        null,
                        null);
                });
        }

        void IAssetMenuOperations.ShowHistory()
        {
            Asset selectedAsset = AssetsSelection.GetSelectedAsset();
            string selectedPath = AssetsSelection.GetSelectedPath();

            WorkspaceTreeNode node = Plastic.API.
                GetWorkspaceTreeNode(selectedPath);

            mHistoryViewLauncher.ShowHistoryView(
                node.RepSpec,
                node.RevInfo.ItemId,
                selectedPath,
                selectedAsset.isFolder);
        }

        static string GetSymbolicName(string selectedPath)
        {
            WorkspaceTreeNode node = Plastic.API.
                GetWorkspaceTreeNode(selectedPath);

            string branchName = string.Empty;
            BranchInfoCache.TryGetBranchName(
                node.RepSpec, node.RevInfo.BranchId, out branchName);

            string userName = Plastic.API.GetUserName(
                node.RepSpec.Server, node.RevInfo.Owner);

            string symbolicName = string.Format(
                "cs:{0}@{1} {2} {3}",
                node.RevInfo.Changeset,
                string.Format("br:{0}", branchName),
                userName,
                "Workspace Revision");

            return symbolicName;
        }

        readonly WorkspaceInfo mWkInfo;
        readonly IViewSwitcher mViewSwitcher;
        readonly IHistoryViewLauncher mHistoryViewLauncher;
        readonly IWorkspaceWindow mWorkspaceWindow;
        readonly ViewHost mViewHost;
        readonly NewIncomingChangesUpdater mNewIncomingChangesUpdater;
        readonly bool mIsGluonMode;
        readonly GuiMessage.IGuiMessage mGuiMessage;
        readonly EditorProgressControls mProgressControls;
    }
}
