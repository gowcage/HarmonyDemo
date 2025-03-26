import hilog from '@ohos.hilog';
import { PermissionUtils } from '../audiopicker/PermissionUtils';
import { common, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';

@Entry
@Component
struct ScanPublicDir {
   TAG = 'ScanPublicDir: hiby->'
   @State message: string = 'Hello World';

   aboutToAppear(): void {
   }

   build() {
      RelativeContainer() {
         Text(this.message)
            .id('ScanPublicDirHelloWorld')
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .alignRules({
               center: { anchor: '__container__', align: VerticalAlign.Center },
               middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .onClick(async () => {
               let permissions: Permissions[] =
                  ['ohos.permission.READ_MEDIA', 'ohos.permission.FILE_ACCESS_PERSIST']
               let dlPermission = await PermissionUtils.checkPermissionGrant(permissions[0])
               let docPermission = await PermissionUtils.checkPermissionGrant(permissions[1])
               hilog.debug(0, this.TAG, `dlPermission: ${dlPermission}, docPermission: ${docPermission}`)

               if (dlPermission == -1 || docPermission == -1) {
                  PermissionUtils.reqPermissionsFromUser(permissions, getContext(this) as common.UIAbilityContext)
                     .then((data: PermissionRequestResult) => {
                        let grantStatus: Array<number> = data.authResults;
                        let length: number = grantStatus.length;
                        for (let i = 0; i < length; i++) {
                           if (grantStatus[i] === 0) {
                              // 用户授权，可以继续访问目标操作
                              hilog.info(0, this.TAG, 'user grant: ' + permissions[i])
                           } else {
                              // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
                              hilog.info(0, this.TAG, 'user reject: ' + permissions[i])
                           }
                        }
                        // 授权成功
                        hilog.info(0, this.TAG, 'user grant')
                     })
                     .catch((err: BusinessError) => {
                        hilog.error(0, this.TAG,
                           `Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`)
                     })
               } else {
                  let dlDirPath = 'file://docs/storage/Users/currentUser/Download'
                  let flist = fs.listFileSync(dlDirPath, {})
                  if (flist && flist.length > 0) {
                     flist.forEach((item) => {
                        hilog.debug(0, this.TAG, 'item: ' + item)
                     })
                  } else {
                     hilog.error(0, this.TAG, 'flist is null')
                  }
               }
            })
      }
      .height('100%')
      .width('100%')
   }
}