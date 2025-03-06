import hilog from "@ohos.hilog"
import { promptAction } from "@kit.ArkUI"

let TAG = 'SideBarDemo: ->'

@Entry
@Component
export struct SideBarDemo {
  private tabCtrl: TabsController = new TabsController()
  @State sideBarWidth: number = 37
  @State containerWidth: number = 50
  @State isShowSidebar: boolean = false
  @State curTabIndex: number = 0

  build() {
    SideBarContainer() {

      // sidebar content
      Column({ space: 20 }) {
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

      // container content
      Column() {
        Tabs({ index: this.curTabIndex, controller: this.tabCtrl }) {
          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.Green)
          }.tabBar('green')
          .onGestureJudgeBegin((info, event) => {
            hilog.debug(0, '***gqz ->',
              `onGestureJudgeBegin: info: ${JSON.stringify(info)}  event: ${JSON.stringify(event)}`)
            // todo: judge left/right pan gesture to return reject/continue
            let e = event as PanGestureEvent
            // if(event typeof PanGestureEvent){}
            let isHorizontal = Math.abs(e.velocityX) / Math.abs(e.velocityY) > 2
            if (isHorizontal && e.velocityX > 0) { // right
              hilog.debug(0, TAG, 'pan right')
              return GestureJudgeResult.CONTINUE
            } else if (this.curTabIndex === 0 && this.isShowSidebar) {
              hilog.debug(0, TAG, 'pan left')
              return GestureJudgeResult.CONTINUE
            }

            return GestureJudgeResult.REJECT
          })
          .gesture(
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
      .backgroundColor(Color.Yellow)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

    }
    .width("200%")
    .sideBarWidth(this.sideBarWidth + '%')
    .divider({ color: Color.Gray, strokeWidth: 1 })
    .showSideBar(this.isShowSidebar)
    .showControlButton(false)
  }
}