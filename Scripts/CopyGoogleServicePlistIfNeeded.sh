# スクリプトが置かれているディレクトリを取得
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

# スクリプトの親ディレクトリを取得
PARENT_DIR=$(dirname "$SCRIPT_DIR")

PLIST_PATH="$PARENT_DIR/univIP/Settings/GoogleService-Info.plist"
TEMPLATE_PLIST_PATH="$PARENT_DIR/univIP/Settings/GoogleService-Info.template.plist"


if [ ! -f "$PLIST_PATH" ]; then
    cp "$TEMPLATE_PLIST_PATH" "$PLIST_PATH"
    echo "GoogleService-Info.plist を作成中です"
else
    echo "GoogleService-Info.plist は既に存在します"
fi