import hilog from "@ohos.hilog"
import { promptAction } from "@kit.ArkUI"

let TAG = 'SideBarDemo: gqz->'

@Entry
@Component
export struct SideBarDemo {
   private tabCtrl: TabsController = new TabsController()
   @State sideBarWidth: number = 37 // todo: keypoint 4
   @State containerWidth: number = 50 // todo: keypoint 4
   @State isShowSidebar: boolean = false
   @State curTabIndex: number = 0

   build() {
      SideBarContainer() {

         Column({ space: 20 }) { // sidebar content
            Button('Btn 1').onClick(() => {
               promptAction.showToast({ message: '1111' })
            })
            Button('Btn 2').onClick(() => {
               promptAction.showToast({ message: '2222' })
            })
            Button('Btn 3').onClick(() => {
               promptAction.showToast({ message: '3333' })
            })
         }.backgroundColor('#ffe2e2e2')

         Column() { // container content
            Tabs({ index: this.curTabIndex, controller: this.tabCtrl }) {
               TabContent() {
                  Column().width('100%').height('100%').backgroundColor(Color.Green)
               }.tabBar('green')
               .onGestureJudgeBegin((info, event) => { // todo: keypoint 1
                  hilog.debug(0, '***gqz ->',
                     `onGestureJudgeBegin: info: ${JSON.stringify(info)}  event: ${JSON.stringify(event)}`)
                  // judge left/right pan gesture to return reject/continue
                  let e = event as PanGestureEvent
                  let isHorizontal = Math.abs(e.velocityX) / Math.abs(e.velocityY) > 2

                  if (isHorizontal && e.velocityX > 0) { // right
                     hilog.debug(0, TAG, 'pan right')
                     return GestureJudgeResult.CONTINUE

                  } else if (this.curTabIndex === 0 && this.isShowSidebar) { // left
                     hilog.debug(0, TAG, 'pan left')
                     return GestureJudgeResult.CONTINUE
                  }

                  return GestureJudgeResult.REJECT
               })
               .gesture( // todo: keypoint 2
                  GestureGroup(
                     GestureMode.Parallel,
                     PanGesture({ direction: PanDirection.Left, distance: 5 }).onActionEnd(() => {
                        animateTo({ duration: 200 }, () => {
                           this.isShowSidebar = false
                           hilog.debug(0, TAG, 'left isShowSidebar: ' + this.isShowSidebar)
                        })
                     }),
                     PanGesture({ direction: PanDirection.Right, distance: 5 }).onActionEnd(() => {
                        animateTo({ duration: 200 }, () => {
                           this.isShowSidebar = true
                           hilog.debug(0, TAG, 'right isShowSidebar: ' + this.isShowSidebar)
                        })
                     })
                  )
               )

               TabContent() {
                  Column().width('100%').height('100%').backgroundColor(Color.Red)
               }.tabBar('red')

               TabContent() {
                  Column().width('100%').height('100%').backgroundColor(Color.Blue)
               }.tabBar('blue')
            }
            .width(this.containerWidth + '%')
            .barMode(BarMode.Fixed)
            .animationDuration(200)
            .onChange((index: number) => {
               this.curTabIndex = index
            })

         }
         // .width(this.containerWidth + '%')
         .backgroundColor(Color.Yellow)
         .alignItems(HorizontalAlign.Start)

      }
      .width("200%") // todo: keypoint 3
      .sideBarWidth(this.sideBarWidth + '%')
      .divider({ color: Color.Gray, strokeWidth: 1 })
      .showSideBar(this.isShowSidebar)
      .showControlButton(false)
   }
}