#!/bin/bash

# 设置 Gradle 权限
chmod +x ./gradlew

# 读取最新的 Kotlin 版本号
VERSION=$(cat versions/kotlin.txt)

# 执行 Gradle 清理和构建 shadowJar
./gradlew clean shadowJar

# 获取 shadowJar 文件路径
JAR_FILE=$(find build/libs -name "*.jar" -print -quit)

# 创建发布说明
RELEASE_NOTES=$(cat CHANGELOG.md 2>/dev/null || echo "No Changes Detected.")

# 删除现有的 tag 和 release（如果存在）
gh release delete "$VERSION" -y
git tag -d "$VERSION"
git push origin :refs/tags/"$VERSION"

# 使用 GitHub CLI 创建新的发布并上传 shadowJar
gh release create "$VERSION" "$JAR_FILE" --title "Kotlin $VERSION" --notes "$RELEASE_NOTES" --target master