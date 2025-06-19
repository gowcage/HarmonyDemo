/*
 * Created by Gqz (gaoqizhi@hiby.com) on 2025/6/17
 */
@Entry
@Component
struct SubWin {
   build() {
      Column() {
         Text('This is a sub window')
            .fontSize(24)
            .fontColor(Color.Black)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Yellow)
      .border({ width: 2, color: 'black', radius: 10 })
   }
}