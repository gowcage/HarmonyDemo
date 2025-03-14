import { add } from 'mylib'
import { TabsDemo } from './tabs/TabsDemo';
import { LengthMetrics, router } from '@kit.ArkUI';
import hilog from '@ohos.hilog';
import { AudioPickerDemo } from './audiopicker/AudioPickerDemo';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';


const permissions: Array<Permissions> = ['ohos.permission.READ_MEDIA', 'ohos.permission.FILE_ACCESS_PERSIST'];

// 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
   let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
   // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
   atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
         if (grantStatus[i] === 0) {
            // 用户授权，可以继续访问目标操作
         } else {
            // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
            return;
         }
      }
      // 授权成功
   }).catch((err: BusinessError) => {
      console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
   })
}


@Entry
@Component
struct Index {
   private arr: string[] =
      ['tabs/TabsDemo', 'tabs/TabsDemo2', 'state/StateDemo', 'audiopicker/AudioPickerDemo', 'sidebar/SideBarDemo',
         'other/OtherDemos', 'drag/DragDemo', 'nodecontroller/NodeControllerDemo']

   aboutToAppear(): void {
      const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      reqPermissionsFromUser(permissions, context)
   }

   build() {
      Column() {
         // Text(add(2,2)+'')

         List({ space: 20, initialIndex: 0 }) {
            ForEach(this.arr, (item: string) => {
               ListItem() {
                  Text(item)
                     .width('100%')
                     .height(50)
                     .fontSize(16)
                     .textAlign(TextAlign.Center)
                     .borderRadius(10)
                  // .onClick((event?: ClickEvent) => {
                  //   console.log('' + item)
                  //   // hilog.debug(0, '***gqz', 'click text')
                  // })
               }.onClick((event?: ClickEvent) => {
                  // console.log('' + item)
                  hilog.debug(0, '***gqz', 'click item: ' + item)
                  router.pushUrl({ url: `pages/${item}`, params: { from: 'Index', to: '' + item } })
               })
            })
         }
         .listDirection(Axis.Vertical) // 排列方向
         .divider({
            strokeWidth: 1,
            color: 0xeeeeee,
            startMargin: 20,
            endMargin: 20
         }) // 每行之间的分界线
         .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
         // .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
         //   console.info('first' + firstIndex)
         //   console.info('last' + lastIndex)
         //   console.info('center' + centerIndex)
         //   hilog.debug(0,'***gqz','onScrollIndex')
         // })
         // .onScrollVisibleContentChange((start: VisibleListContentInfo, end: VisibleListContentInfo) => {
         //   console.log(' start index: ' + start.index +
         //     ' start item group area: ' + start.itemGroupArea +
         //     ' start index in group: ' + start.itemIndexInGroup)
         //   console.log(' end index: ' + end.index +
         //     ' end item group area: ' + end.itemGroupArea +
         //     ' end index in group: ' + end.itemIndexInGroup)
         // })
         // .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
         //   console.info(`onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
         // })
         .width('100%')
         .fadingEdge(true, { fadingEdgeLength: LengthMetrics.vp(50) })
      }
   }
}