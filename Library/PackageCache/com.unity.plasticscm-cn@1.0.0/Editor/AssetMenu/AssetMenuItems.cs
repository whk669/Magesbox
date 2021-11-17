using UnityEditor;

using Unity.PlasticSCM.Editor.UI;
using Unity.PlasticSCM.Editor.AssetsOverlays.Cache;

namespace Unity.PlasticSCM.Editor.AssetMenu
{
    internal class AssetMenuItems
    {
        internal static void Enable(
            IAssetMenuOperations operations,
            IAssetStatusCache assetStatusCache)
        {
            mOperations = operations;
            mAssetStatusCache = assetStatusCache;

            mIsEnabled = true;
        }

        internal static void Disable()
        {
            mIsEnabled = false;
        }

        [MenuItem(PENDING_CHANGES_MENU_ITEM_NAME, false, PENDING_CHANGES_MENU_ITEM_PRIORITY)]
        internal static void PendingChanges()
        {
            ShowWindow.Plastic();

            mOperations.ShowPendingChanges();
        }

        [MenuItem(PENDING_CHANGES_MENU_ITEM_NAME, true, PENDING_CHANGES_MENU_ITEM_PRIORITY)]
        internal static bool ValidatePendingChanges()
        {
            return mIsEnabled;
        }

        [MenuItem(CHECKOUT_MENU_ITEM_NAME, false, CHECKOUT_MENU_ITEM_PRIORITY)]
        internal static void Checkout()
        {
            mOperations.Checkout();
        }

        [MenuItem(CHECKOUT_MENU_ITEM_NAME, true, CHECKOUT_MENU_ITEM_PRIORITY)]
        static bool ValidateCheckout()
        {
            return ShouldMenuItemBeEnabled(AssetMenuOperations.Checkout);
        }

        [MenuItem(DIFF_MENU_ITEM_NAME, false, DIFF_MENU_ITEM_PRIORITY)]
        internal static void Diff()
        {
            mOperations.ShowDiff();
        }

        [MenuItem(DIFF_MENU_ITEM_NAME, true, DIFF_MENU_ITEM_PRIORITY)]
        static bool ValidateDiff()
        {
            return ShouldMenuItemBeEnabled(AssetMenuOperations.Diff);
        }

        [MenuItem(HISTORY_MENU_ITEM_NAME, false, HISTORY_MENU_ITEM_PRIORITY)]
        internal static void History()
        {
            ShowWindow.Plastic();

            mOperations.ShowHistory();
        }

        [MenuItem(HISTORY_MENU_ITEM_NAME, true, HISTORY_MENU_ITEM_PRIORITY)]
        static bool ValidateHistory()
        {
            return ShouldMenuItemBeEnabled(AssetMenuOperations.History);
        }

        static bool ShouldMenuItemBeEnabled(AssetMenuOperations operation)
        {
            if (mOperations == null)
                return false;

            SelectedAssetGroupInfo selectedGroupInfo = SelectedAssetGroupInfo.
                BuildFromAssetList(
                    AssetsSelection.GetSelectedAssets(),
                    mAssetStatusCache);

            AssetMenuOperations operations = AssetMenuUpdater.
                GetAvailableMenuOperations(selectedGroupInfo);

            return operations.HasFlag(operation);
        }

        static IAssetMenuOperations mOperations;
        static IAssetStatusCache mAssetStatusCache;
        static bool mIsEnabled;

        const string ASSETS_MENU_ITEM_NAME = "Assets/";
        const string PLASTIC_MENU_ITEM_NAME = ASSETS_MENU_ITEM_NAME + "Plastic SCM/";
        const string PENDING_CHANGES_MENU_ITEM_NAME = PLASTIC_MENU_ITEM_NAME + "Show pending changes view";
        const string CHECKOUT_MENU_ITEM_NAME = PLASTIC_MENU_ITEM_NAME + "Checkout";
        const string DIFF_MENU_ITEM_NAME = PLASTIC_MENU_ITEM_NAME + "Diff with previous revision #%d";
        const string HISTORY_MENU_ITEM_NAME = PLASTIC_MENU_ITEM_NAME + "View file history %h";

        const int BASE_MENU_ITEM_PRIORITY = 19; // Puts Plastic SCM right below Create menu

        // incrementing the "order" param by 11 causes the menu system to add a separator
        const int PENDING_CHANGES_MENU_ITEM_PRIORITY = BASE_MENU_ITEM_PRIORITY;
        const int CHECKOUT_MENU_ITEM_PRIORITY = PENDING_CHANGES_MENU_ITEM_PRIORITY + 11;
        const int DIFF_MENU_ITEM_PRIORITY = PENDING_CHANGES_MENU_ITEM_PRIORITY + 12;
        const int HISTORY_MENU_ITEM_PRIORITY = PENDING_CHANGES_MENU_ITEM_PRIORITY + 23;
    }
}
