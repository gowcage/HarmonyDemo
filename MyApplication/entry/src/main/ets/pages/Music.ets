import { SharedAction } from "./TabsDemo"

@Component
export struct Music {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentSubIndex: number = 0
  private controller: TabsController = new TabsController()
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Right, distance: 1 });
  //
  @Consume changeTabHandler: SharedAction

  @Builder
  subTabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentSubIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentSubIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentSubIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, index: this.currentSubIndex, controller: this.controller }) {

      TabContent() {
        Column() {
          Text('SubTab 5')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#ff58603d')
      }.tabBar(this.subTabBuilder(0, 'SubTab 5'))
      .gesture(
        PanGesture(this.panOption).onActionEnd(() => {
          this.changeTabHandler.changeParentTabs(0)
        })
      )

      TabContent() {
        Column() {
          Text('SubTab 6')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor('#ff584428')
      }.tabBar(this.subTabBuilder(1, 'SubTab 6'))

    }
    .vertical(false)
    .barMode(BarMode.Fixed)
    .barWidth(360)
    .barHeight(56)
    .animationDuration(400)
    .onChange((index: number) => {
      // currentIndex控制TabContent显示页签
      // animateTo({ duration: 300 }, () => {
        this.currentSubIndex = index
      // })
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}