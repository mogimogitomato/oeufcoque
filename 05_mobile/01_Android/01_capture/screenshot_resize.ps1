$now = Get-Date -format "yyyyMMdd-HHmmss"
$pic_name = "ScreenShot_" + $now + ".jpeg"

# 端末からスクリーンショットを取得
adb shell screencap -p /sdcard/$pic_name
adb pull /sdcard/$pic_name
adb shell rm /sdcard/$pic_name

$current_path = Split-Path -Parent $MyInvocation.MyCommand.Path
$org_jpeg = $current_path + "\" + $pic_name
$resize_jpeg = $current_path + "\" + "ScreenShot_" + $now + "_resize" + ".jpeg"

# アセンブリの読み込み
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# 画像ファイルの読み込み
$image = New-Object System.Drawing.Bitmap($org_jpeg)

# 縮小先のオブジェクトを生成
$canvas = New-Object System.Drawing.Bitmap([int]($image.Width / 4), [int]($image.Height / 4))

# 縮小先へ描画
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.DrawImage($image, (New-Object System.Drawing.Rectangle(0, 0, $canvas.Width, $canvas.Height)))

# 保存
$canvas.Save($resize_jpeg, [System.Drawing.Imaging.ImageFormat]::Jpeg)

# オブジェクトの破棄
$graphics.Dispose()
$canvas.Dispose()
$image.Dispose()

# 元の画像を破棄
rm $org_jpeg -r