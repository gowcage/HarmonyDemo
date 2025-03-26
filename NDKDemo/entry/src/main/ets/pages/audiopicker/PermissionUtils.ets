import {
   abilityAccessCtrl,
   bundleManager,
   Permissions,
   UIAbility,
   common,
   PermissionRequestResult
} from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';

export class PermissionUtils {
   static async checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

      // 获取应用程序的accessTokenID
      let tokenId: number = 0;
      try {
         let bundleInfo: bundleManager.BundleInfo =
            await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
         let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
         tokenId = appInfo.accessTokenId;
      } catch (error) {
         const err: BusinessError = error as BusinessError;
         console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
      }

      // 校验应用是否被授予权限
      try {
         grantStatus = await atManager.checkAccessToken(tokenId, permission);
      } catch (error) {
         const err: BusinessError = error as BusinessError;
         console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
      }

      return grantStatus;
   }

   // 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
   static async reqPermissionsFromUser(permissions: Array<Permissions>,
      context: common.UIAbilityContext): Promise<PermissionRequestResult> {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
      let data = await atManager.requestPermissionsFromUser(context, permissions)
      return data
   }

   // 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
   static async reqPermissionsFromUser2(permissions: Array<Permissions>,
      context: common.UIAbilityContext): Promise<boolean> {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
      atManager.requestPermissionsFromUser(context, permissions).then((data) => {
         let grantStatus: Array<number> = data.authResults;
         let length: number = grantStatus.length;
         for (let i = 0; i < length; i++) {
            if (grantStatus[i] === 0) {
               // 用户授权，可以继续访问目标操作
               return true
            } else {
               // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
               return false
            }
         }
         // 授权成功
         return true
      }).catch((err: BusinessError) => {
         console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);

      })
      return false
   }
}