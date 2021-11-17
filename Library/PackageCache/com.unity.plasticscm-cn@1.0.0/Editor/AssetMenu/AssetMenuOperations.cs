using System;
using System.IO;

using UnityEditor.VersionControl;

using Codice;
using Codice.Client.Commands.WkTree;

using PlasticGui;
using Unity.PlasticSCM.Editor.AssetsOverlays.Cache;
using Unity.PlasticSCM.Editor.AssetsOverlays;

namespace Unity.PlasticSCM.Editor.AssetMenu
{
    [Flags]
    internal enum AssetMenuOperations : byte
    {
        None =                   0,
        Checkout =               1 << 0,
        Diff =                   1 << 1,
        History =                1 << 2
    }

    internal class SelectedAssetGroupInfo
    {
        internal int SelectedCount;

        internal bool IsControlledSelection;
        internal bool IsCheckedInSelection;
        internal bool IsFileSelection;
        internal bool HasAnyAddedInSelection;
        internal bool HasAnyRemoteLockedInSelection;

        internal static SelectedAssetGroupInfo BuildFromAssetList(
            AssetList assetList,
            IAssetStatusCache statusCache)
        {
            bool isCheckedInSelection = true;
            bool isControlledSelection = true;
            bool isFileSelection = true;
            bool hasAnyAddedInSelection = false;
            bool hasAnyRemoteLockedInSelection = false;

            foreach (Asset asset in assetList)
            {
                string assetPath = Path.GetFullPath(asset.path);

                WorkspaceTreeNode wkTreeNode =
                    Plastic.API.GetWorkspaceTreeNode(assetPath);

                if (asset.isFolder)
                    isFileSelection = false;

                if (CheckWorkspaceTreeNodeStatus.IsPrivate(wkTreeNode))
                    isControlledSelection = false;

                if (CheckWorkspaceTreeNodeStatus.IsCheckedOut(wkTreeNode))
                    isCheckedInSelection = false;

                if (CheckWorkspaceTreeNodeStatus.IsAdded(wkTreeNode))
                    hasAnyAddedInSelection = true;

                if (ClassifyAssetStatus.IsLockedRemote(statusCache.GetStatusForPath(assetPath)))
                    hasAnyRemoteLockedInSelection = true;
            }

            return new SelectedAssetGroupInfo()
            {
                IsCheckedInSelection = isCheckedInSelection,
                IsControlledSelection = isControlledSelection,
                IsFileSelection = isFileSelection,
                HasAnyAddedInSelection = hasAnyAddedInSelection,
                HasAnyRemoteLockedInSelection = hasAnyRemoteLockedInSelection,
                SelectedCount = assetList.Count,
            };
        }

    }

    internal interface IAssetMenuOperations
    {
        void ShowPendingChanges();
        void Checkout();
        void ShowDiff();
        void ShowHistory();
    }

    internal static class AssetMenuUpdater
    {
        internal static AssetMenuOperations GetAvailableMenuOperations(
            SelectedAssetGroupInfo info)
        {
            AssetMenuOperations result = AssetMenuOperations.None;

            if (info.IsControlledSelection &&
                info.IsCheckedInSelection &&
                info.IsFileSelection &&
                !info.HasAnyRemoteLockedInSelection)
                result |= AssetMenuOperations.Checkout;

            if (info.SelectedCount == 1 &&
                info.IsControlledSelection &&
                !info.HasAnyAddedInSelection &&
                info.IsFileSelection)
            {
                result |= AssetMenuOperations.Diff;
            }

            if (info.SelectedCount == 1 &&
                info.IsControlledSelection &&
                !info.HasAnyAddedInSelection)
            {
                result |= AssetMenuOperations.History;
            }

            return result;
        }
    }
}
