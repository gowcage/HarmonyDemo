import { TransitionComp } from "./TransitionComp"

@Entry
@Component
export struct AnimationDemo {
   @State fontColor: string = '#182431'
   @State selectedFontColor: string = '#007DFF'
   @State currentIndex: number = 0
   private comps: string[] = ['Transition']

   @Builder
   getComp(name: string) {
      if (name === this.comps[0]) {
         TransitionComp()
      }
   }

   @Builder
   tabBarBuilder(index: number, name: string) {
      Column() {
         Text(name)
            .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
            .fontSize(16)
            .fontWeight(this.currentIndex === index ? 500 : 300)
            .lineHeight(22)
            .margin({ top: 17, bottom: 7 })
         Divider()
            .strokeWidth(2)
            .color('#007DFF')
            .width(this.currentIndex === index ? '100%' : 0)
      }.width('25%')
   }

   build() {
      Tabs() {
         ForEach(this.comps, (item: string, index: number) => {
            TabContent() {
               this.getComp(item)
            }.tabBar(this.tabBarBuilder(index, item))
         })
      }.barMode(BarMode.Scrollable)
      .fadingEdge(true)
      .edgeEffect(EdgeEffect.Spring)
   }
}