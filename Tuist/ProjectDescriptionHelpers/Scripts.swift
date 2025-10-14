import ProjectDescription

// MARK: - Build Scripts

public enum BuildScripts {
    /// Script to copy the appropriate GoogleService-Info.plist based on build configuration
    public static let firebaseConfig = TargetScript.pre(
        script: """
        # Copy the appropriate GoogleService-Info.plist based on configuration
        CONFIG_NAME="${CONFIGURATION}"
        SOURCE_PLIST="${SRCROOT}/Resources/Firebase/GoogleService-Info-${CONFIG_NAME}.plist"
        DEST_PLIST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

        # Skip for test action (testing doesn't need Firebase config)
        if [ "${ACTION}" = "test" ]; then
            echo "ℹ️  Skipping Firebase config copy for test action"
            exit 0
        fi

        if [ -f "$SOURCE_PLIST" ]; then
            echo "✅ Copying GoogleService-Info-${CONFIG_NAME}.plist"
            cp "$SOURCE_PLIST" "$DEST_PLIST"
        else
            echo "⚠️  Warning: $SOURCE_PLIST not found"
            echo "   This is OK for CI tests, but required for real builds"
            exit 0
        fi
        """,
        name: "Copy Firebase Config",
        basedOnDependencyAnalysis: false
    )

    /// Script to upload dSYMs to Firebase Crashlytics after build
    public static let crashlyticsUpload = TargetScript.post(
        script: """
        # Upload dSYMs to Firebase Crashlytics
        # This script runs after build to upload debug symbols for crash symbolication

        # Only run for release builds or when explicitly enabled
        if [ "${CONFIGURATION}" != "Dev" ]; then
            echo "🔥 Uploading dSYMs to Firebase Crashlytics..."

            # Find the upload-symbols script in Tuist dependencies
            UPLOAD_SCRIPT="${PROJECT_DIR}/../Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"

            echo "   Looking for script at: ${UPLOAD_SCRIPT}"

            if [ ! -f "$UPLOAD_SCRIPT" ]; then
                echo "⚠️  Crashlytics upload-symbols script not found at ${UPLOAD_SCRIPT}"
                echo "   Skipping dSYM upload - this is normal for simulator builds"
                exit 0
            fi

            # Check if dSYM exists
            if [ ! -d "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}" ]; then
                echo "⚠️  dSYM not found at ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
                echo "   Make sure DEBUG_INFORMATION_FORMAT is set to dwarf-with-dsym"
                exit 0
            fi

            # Upload symbols
            echo "   Uploading dSYMs..."
            GOOGLE_PLIST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
            DSYM_PATH="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
            "$UPLOAD_SCRIPT" -gsp "$GOOGLE_PLIST" -p ios "$DSYM_PATH"

            if [ $? -eq 0 ]; then
                echo "✅ dSYMs uploaded successfully to Crashlytics"
            else
                echo "❌ Failed to upload dSYMs"
                exit 1
            fi
        else
            echo "ℹ️  Skipping dSYM upload for Dev configuration"
        fi
        """,
        name: "Upload dSYMs to Crashlytics",
        basedOnDependencyAnalysis: false
    )
}
