using NUnit.Framework;

using Unity.PlasticSCM.Editor;
using Unity.PlasticSCM.Editor.AssetMenu;

namespace Unity.PlasticSCM.Tests.Editor.AssetMenu
{
    [TestFixture]
    class AssetMenuUpdaterTests
    {
        [Test]
        public void TestCheckoutMenuEnabledForSingleSelection()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Checkout));
        }

        [Test]
        public void TestCheckoutMenuEnabledForMultipleSelection()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 5,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Checkout));
        }

        [Test]
        public void TestCheckoutMenuDisabledForFolders()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = false,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Checkout));
        }

        [Test]
        public void TestCheckoutMenuDisabledForAlreadyCheckedoutFiles()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Checkout));
        }

        [Test]
        public void TestCheckoutMenuDisabledForNotControlledSelection()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = false,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Checkout));
        }

        [Test]
        public void TestDiffMenuEnabledForCheckedInFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestDiffMenuEnabledForCheckedOutFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestDiffIsDisabledForFolders()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = false,
                IsCheckedInSelection = false,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestDiffIsDisabledForPrivateItems()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = false,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestDiffMenuDisabledForMultipleSelection()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 5,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestDiffMenuDisabledForAddedFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = true,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.Diff));
        }

        [Test]
        public void TestHistoryMenuEnabledForCheckedInFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }

        [Test]
        public void TestHistoryMenuEnabledForCheckedOutFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }

        [Test]
        public void TestHistoryIsEnabledForFolders()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = false,
                IsCheckedInSelection = false,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsTrue(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }

        [Test]
        public void TestHistoryIsDisabledForPrivateItems()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = false,
                IsControlledSelection = false,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }

        [Test]
        public void TestHistoryMenuDisabledForMultipleSelection()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 5,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = false,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }


        [Test]
        public void TestHistoryMenuDisabledForAddedFile()
        {
            SelectedAssetGroupInfo groupInfo = new SelectedAssetGroupInfo()
            {
                SelectedCount = 1,
                IsFileSelection = true,
                IsCheckedInSelection = true,
                IsControlledSelection = true,
                HasAnyAddedInSelection = true,
            };

            Assert.IsFalse(
                AssetMenuUpdater.GetAvailableMenuOperations(groupInfo)
                .HasFlag(AssetMenuOperations.History));
        }
    }
}
