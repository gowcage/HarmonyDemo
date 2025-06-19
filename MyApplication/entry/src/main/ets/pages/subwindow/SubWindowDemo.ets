/*
 * Created by Gqz (gaoqizhi@hiby.com) on 2025/6/17
 */
import { ColorMetrics, window } from "@kit.ArkUI";
import hilog from "@ohos.hilog";
import { BusinessError } from "@kit.BasicServicesKit";

@Entry
@Component
export struct SubWindowDemo {
   private readonly TAG = 'SubWindowDemo: ***'
   //
   @StorageLink('winStage') winStage: window.WindowStage | undefined = undefined;
   //
   sub_win: window.Window | undefined = undefined

   aboutToAppear(): void {

   }

   createSubWin() {
      // 1. 创建子窗口
      if (this.winStage && !this.sub_win) {
         let opt: window.SubWindowOptions = {
            title: '子窗口',
            decorEnabled: true
         }
         this.winStage.createSubWindowWithOptions('mySubWin', opt).then((win) => {
            this.sub_win = win
            // 2. 子窗口创建成功后，设置子窗口的位置、大小及相关属性等
            this.sub_win.moveWindowTo(500, 200, (err) => {
               hilog.error(0, this.TAG, `moveWindowTo err:${JSON.stringify(err)}`)
            })
            this.sub_win.resize(600, 1000, (err) => {
               hilog.error(0, this.TAG, `resize err:${JSON.stringify(err)}`)
            })
            // 3.为子窗口加载对应的目标页面
            this.sub_win.setUIContent('pages/subwindow/SubWin', (err) => {
               hilog.error(0, this.TAG, `setUIContent err:${JSON.stringify(err)}`)
               // 4.显示子窗口
               this.sub_win?.showWindow((err) => {
                  hilog.error(0, this.TAG, `showWindow err:${JSON.stringify(err)}`)
                  this.sub_win?.setWindowDecorVisible(true)
                  this.sub_win?.setWindowTouchable(true)
                  this.sub_win?.setWindowCornerRadius(20)
               })
            })
         }).catch((err: BusinessError) => {
            hilog.error(0, this.TAG, `err:${JSON.stringify(err)}`)
         })
      }
   }

   destroySubWin() {
      // 5.销毁子窗口
      if (this.sub_win) {
         this.sub_win.destroyWindow((err) => {
            hilog.error(0, this.TAG, `destroyWindow err:${JSON.stringify(err)}`)
            if (err.code == 0) {
               this.sub_win = undefined
            }
         })
      }
   }

   build() {
      Column({ space: 30 }) {
         Text('SubWindowDemo')
         Button('创建子窗口').onClick(() => {
            this.createSubWin()
         })
         Button('销毁子窗口').onClick(() => {
            this.destroySubWin()
         })
      }
      .onTouch((event) => {
         switch (event.type) {
            case TouchType.Down:
               break
            case TouchType.Move:
               break
            case TouchType.Up:
               break
         }
      })
   }
}


