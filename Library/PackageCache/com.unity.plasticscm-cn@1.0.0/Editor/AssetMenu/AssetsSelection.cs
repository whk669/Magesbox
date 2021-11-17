using System.Collections.Generic;
using System.IO;

using UnityEditor.VersionControl;

namespace Unity.PlasticSCM.Editor.AssetMenu
{
    internal static class AssetsSelection
    {
        internal static AssetList GetSelectedAssets()
        {
            return Provider.GetAssetListFromSelection();
        }

        internal static Asset GetSelectedAsset()
        {
            AssetList assetList = Provider.GetAssetListFromSelection();

            if (assetList.Count == 0)
                return null;

            return assetList[0];
        }

        internal static string GetSelectedPath()
        {
            AssetList assetList = Provider.GetAssetListFromSelection();

            if (assetList.Count == 0)
                return null;

            return Path.GetFullPath(assetList[0].path);
        }

        internal static List<string> GetSelectedPathsWithMeta()
        {
            return GetSelectedPaths(true);
        }

        static List<string> GetSelectedPaths(bool includeMeta)
        {
            AssetList assetList = Provider.GetAssetListFromSelection();

            List<string> result = new List<string>();

            foreach (Asset asset in assetList)
            {
                string fullPath = Path.GetFullPath(asset.path);
                result.Add(fullPath);

                if (!includeMeta)
                    continue;

                string metaPath = MetaPath.GetMetaPath(fullPath);

                if (File.Exists(metaPath))
                    result.Add(metaPath);
            }

            return result;
        }
    }
}
