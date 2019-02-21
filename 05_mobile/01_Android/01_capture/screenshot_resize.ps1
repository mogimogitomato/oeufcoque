$now = Get-Date -format "yyyyMMdd-HHmmss"
$pic_name = "ScreenShot_" + $now + ".jpeg"

# �[������X�N���[���V���b�g���擾
adb shell screencap -p /sdcard/$pic_name
adb pull /sdcard/$pic_name
adb shell rm /sdcard/$pic_name

$current_path = Split-Path -Parent $MyInvocation.MyCommand.Path
$org_jpeg = $current_path + "\" + $pic_name
$resize_jpeg = $current_path + "\" + "ScreenShot_" + $now + "_resize" + ".jpeg"

# �A�Z���u���̓ǂݍ���
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# �摜�t�@�C���̓ǂݍ���
$image = New-Object System.Drawing.Bitmap($org_jpeg)

# �k����̃I�u�W�F�N�g�𐶐�
$canvas = New-Object System.Drawing.Bitmap([int]($image.Width / 4), [int]($image.Height / 4))

# �k����֕`��
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.DrawImage($image, (New-Object System.Drawing.Rectangle(0, 0, $canvas.Width, $canvas.Height)))

# �ۑ�
$canvas.Save($resize_jpeg, [System.Drawing.Imaging.ImageFormat]::Jpeg)

# �I�u�W�F�N�g�̔j��
$graphics.Dispose()
$canvas.Dispose()
$image.Dispose()

# ���̉摜��j��
rm $org_jpeg -r