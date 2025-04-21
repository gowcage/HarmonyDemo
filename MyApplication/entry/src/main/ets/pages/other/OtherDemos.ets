import { hilog } from "@kit.PerformanceAnalysisKit"
import { promptAction } from "@kit.ArkUI"

let TAG = 'OtherDemos: gqz->'


@Entry
@Component
export struct OtherDemos {
   build() {

   }
}

/*@Entry
@Component
export struct OtherDemos {
   @State arr: number[] = [1, 2, 3, 4]

   build() {
      Column() {
         Text('=============')
            .fontSize(24)
            .height(50)
            .width('100%')
            .border({ width: 1, color: 'black' })
            .onClick(() => {
               this.arr.push(this.arr.length + 1)
            })

         Scroll() {
            Column() {
               ForEach(this.arr, (item: number, index: number) => {
                  Text('item ' + item)
                     .fontSize(24)
                     .height(50)
                     .width('100%')
                     .border({ width: 1, color: 'black' })
               })
            }
         }
         .align(Alignment.Top)
         .layoutWeight(1)
         .border({ width: 1, color: 'red' })

         Text('=============')
            .fontSize(24)
            .height(50)
            .width('100%')
            .border({ width: 1, color: 'black' })
      }.height("50%").width('100%')
      .border({ width: 2, color: 'green' })
   }
}*/

class TextInfoItem {
   key: string = ''
   value: string = ''

   constructor(key: string, value: string) {
      this.key = key
      this.value = value
   }
}

let infos: TextInfoItem[] = [
   new TextInfoItem('歌曲名：', '爱人错过'),
   new TextInfoItem('专辑：', '我肯定在几百年前就说过爱你'),
   new TextInfoItem('艺术家：', '告五人'),
   new TextInfoItem('专辑艺术家：', '未知'),
   new TextInfoItem('风格：', '未知'),
   new TextInfoItem('位置：', '/storage/emulated/0/Music/爱人错过_告五人我肯定在几百年前就说过爱你.mp3'),
   new TextInfoItem('年代：', '未知'),
   new TextInfoItem('时长：', '04:52'),
   new TextInfoItem('大小：', '4.54MB'),
   new TextInfoItem('采样率：', '48.0kHZ'),
   new TextInfoItem('格式：', 'MPEG-Layer 3'),
   new TextInfoItem('比特率：', '128kbps'),
   new TextInfoItem('位深：', '16 bits'),
   new TextInfoItem('起始播放点：', '00:00'),
   new TextInfoItem('声道：', '2'),
   new TextInfoItem('质量评分：', '1'),
   new TextInfoItem('音轨号：', '0'),
   new TextInfoItem('唱片编号：', '0'),
   new TextInfoItem('播放次数：', '19'),
   new TextInfoItem('', ''),// holder place
]

@Builder
function TextInfoItem1Builder(info: TextInfoItem) {
   Row() {
      Text(info.key)
         .fontSize(16)
         .fontWeight(300)
         .fontColor('black')
      Text(info.value)
         .fontSize(16)
         .fontWeight(300)
         .fontColor('gray')
         .layoutWeight(1)
         .lineBreakStrategy(LineBreakStrategy.GREEDY)

   }
   .clip(true)
   .alignItems(VerticalAlign.Top)
}

/*@Preview
@Entry
@Component
struct OtherDemos {
   build() {
      Column() {
         Text('歌曲信息')
            .fontSize(16)
            .fontWeight(400)
            .height(40)
            .padding({ left: 8 })
         Divider().height(1).color('gray')
         Scroll() {
            Column({ space: 24 }) {
               ForEach(infos.slice(0, 6), (info: TextInfoItem, index) => {
                  TextInfoItem1Builder(info)
               })

               Text('歌曲信息乱码？')
                  .fontColor('gray')
                  .fontSize(14)
                  .border({ width: { bottom: 1}, color: 'gray' })
                  .textAlign(TextAlign.Center)
                  .onClick(() => {
                     promptAction.showToast({ message: '乱码' })
                  })

               Divider().height(1).color('gray')

               Row() {
                  Column({ space: 24 }) {
                     ForEach(infos.slice(6, infos.length), (info: TextInfoItem, index) => {
                        if (index % 2 == 0) {
                           TextInfoItem1Builder(info)
                        }
                     })
                  }.layoutWeight(1)

                  Column({ space: 24 }) {
                     ForEach(infos.slice(6, infos.length), (info: TextInfoItem, index) => {
                        if (index % 2 == 1) {
                           TextInfoItem1Builder(info)
                        }
                     })
                  }.layoutWeight(1)

               }.alignItems(VerticalAlign.Top)
            }
            .padding({
               left: 8,
               right: 8,
               top: 16,
               bottom: 16
            })
         }
         .width('100%')
         .layoutWeight(1)
      }
      .height('50%')
      .alignItems(HorizontalAlign.Start)
      .border({ width: 1, color: 'black' })
   }
}*/

@Builder
function Bg(res: Resource, blur: BlurStyle) {
   Image(res)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Contain)
      .backgroundBlurStyle(blur)
}

@Builder
function Txt(blur: number) {
   Text()
      .backgroundImage($r('app.media.bg'))
      .backgroundImageSize({ width: 125, height: 100 })
      .width(125)
      .height(100)
      .border({ width: 1, color: 'black' })
      .blur(blur)
}

/*@Entry
@Component
struct OtherDemos {
   aboutToAppear(): void {
      let arr: number[] = [1, 2, 3, 4, 5]
      let arrStr = JSON.stringify(arr)
      hilog.debug(0, TAG, '' + arrStr)
      let arr2: number[] = JSON.parse(arrStr)
      hilog.debug(0, TAG, '' + arr2)
      hilog.debug(0, TAG, '' + arr2[2])
   }

   build() {

   }
}*/

/*@Entry
@Component
struct OtherDemos {
   @State blur1: number = 0
   @State blur2: number = 0

   aboutToAppear(): void {
      hilog.info(0x00, TAG, 'aboutToAppear')
   }

   onDidBuild(): void {
      hilog.info(0x00, TAG, 'onDidBuild')
   }

   aboutToDisappear(): void {
      hilog.info(0x00, TAG, 'aboutToDisappear')
   }

   onPageShow(): void {
      hilog.info(0x00, TAG, 'onPageShow')
   }

   onPageHide(): void {
      hilog.info(0x00, TAG, 'onPageHide')
   }

   onBackPress(): boolean | void {
      hilog.info(0x00, TAG, 'onBackPress')
      return false
   }

   build() {
      Scroll() {
         Column({ space: 16 }) {
            Slider({ value: this.blur1, min: 0, max: 200 })
               .onChange((value: number, mode: SliderChangeMode) => {
                  this.blur1 = value
               })
            Text('Blur: ' + this.blur1).fontSize(16)
            Image($r('app.media.bg')).blur(this.blur1)
               .width('100%')

            Blank().height(50)

            Slider({ value: this.blur2, min: 0, max: 200 })
               .onChange((value: number, mode: SliderChangeMode) => {
                  this.blur2 = value
               })
            Text('Blur: ' + this.blur2).fontSize(16)
            Image($r('app.media.bg')).blur(this.blur2)
               .width('100%')

            Column({ space: 12 }) {
               Text('中国智造 Made In China 12340').fontSize(16).fontColor('#1c1c1c')
               Text('中国智造 Made In China 12340').fontSize(16).fontColor('#701c1c1c')
            }.backgroundColor(Color.White).padding(16)

            Column({ space: 12 }) {
               Text('中国智造 Made In China 12340').fontSize(16).fontColor('#e8e8e8')
               Text('中国智造 Made In China 12340').fontSize(16).fontColor('#90e8e8e8')
            }.backgroundColor(Color.Black).padding(16)

            Row(){
               Text().width(30).height(30).border({ width: 1, color: 'red'})
               Text().width(30).height(30).border({ width: 1, color: 'black'}).layoutWeight(1)
               Text().width(30).height(30).border({ width: 1, color: 'blue'})
            }
            Column(){
               Text().width(30).height(30).border({ width: 1, color: 'red'})
               Text().width(30).height(30).border({ width: 1, color: 'black'}).layoutWeight(1)
               Text().width(30).height(30).border({ width: 1, color: 'blue'})
            }.height(120)
         }
      }
   }
}*/

/*@Entry
@Component
struct OtherDemos {
   build() {
      Column({ space: 20 }) {
         Row() {
            Txt(0)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(1)
            Txt(3)
            Txt(5)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(10)
            Txt(20)
            Txt(30)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(50)
            Txt(100)
            Txt(150)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)

         Row() {
            Txt(300)
            Txt(600)
            Txt(900)
         }.width('100%')
         .justifyContent(FlexAlign.SpaceBetween)
      }
   }
}*/


@Preview
@Component
export struct FontSize {
   titleSize1: string = '10fp'
   titleSize2: string = '10fp'
   quoteSize: string = '10fp'
   fontSize: string = '10fp'

   build() {
      Column() {
         Text('标题1 Title1 123').fontSize(this.titleSize1).fontColor('#222')
         Divider()
            .height(1)
            .color('#999')
            .width('100%')
            .padding({
               top: 10,
               bottom: 10,
               left: 5,
               right: 5
            })
         Text('标题2 Title2 123').fontSize(this.titleSize2).fontColor('#222')
         Text('引用 Quote 123 引用 Quote 123 引用 Quote 123')
            .fontSize(this.quoteSize)
            .fontColor('#999')
            .margin({ top: 5 })
         Text('正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123 正文 Content 123')
            .fontSize(this.fontSize)
            .fontColor('#333')
            .margin({ top: 10 })
      }.alignItems(HorizontalAlign.Start)
      .border({ width: 1, color: '#aaa' })
      .padding(10)
   }
}

@Component
struct A {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Column() {
            Text('11111111')
            Text('22222222')
         }

         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
   }
}

@Component
struct B {
   build() {
      Column() {
         Image($r('app.media.startIcon')).width(150).height(150).margin({ top: 30, bottom: 30 })
         C()
         D()
         E()
      }
      .width('100%')
      .layoutWeight(1)
      .border({ width: 2, color: 'green' })
   }
}

@Component
struct C {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Image($r('app.media.startIcon')).width(40).height(40)
         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: 30 })
   }
}

@Component
struct D {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(40).height(40)
         Row() {
            Text('11111111')
            Divider().vertical(true).strokeWidth(2).height(20).color('white')
            Text('22222222')
            Divider().vertical(true).strokeWidth(2).height(20).color('white')
            Text('33333333')
         }

         Image($r('app.media.startIcon')).width(40).height(40)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .margin({ top: 30, bottom: 30 })
   }
}

@Component
struct E {
   build() {
      Row() {
         Image($r('app.media.startIcon')).width(36).height(36)
         Image($r('app.media.startIcon')).width(42).height(42)
         Image($r('app.media.startIcon')).width(36).height(36)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .layoutWeight(1)
   }
}


/*@Entry
@Component
export struct OtherDemos {
   build() {
      Column() {
         Row() {
            Button()
            Button()
            Button()
         }

         Row() {
            Text('11111111').onClick(() => {
               hilog.debug(0, TAG, 'onClick...')
            }).onTouch((event: TouchEvent) => {
               hilog.debug(0, TAG, 'onTouch...')
            })
            Text('22222222')
         }.justifyContent(FlexAlign.SpaceBetween)
         .width('100%')

         Divider().strokeWidth(2).color('black').margin({ top: 20, bottom: 20 })

         A()

         B()
      }
      .width('100%')
      .height('100%')
      .border({ width: 3, color: 'black' })
   }
}*/


/*@Entry
@Component
export struct OtherDemos {
   aboutToAppear(): void {

   }

   build() {
      Scroll() {
         Column({ space: 20 }) {
            Text('自定义尺寸').fontSize(20).fontColor('#222')
            Divider()
               .height(1)
               .color('#999')
               .width('100%')
               .padding({
                  top: 10,
                  bottom: 10,
               })
            FontSize({
               titleSize1: '18fp',
               titleSize2: '14fp',
               quoteSize: '10fp',
               fontSize: '12fp'
            })
            FontSize({
               titleSize1: '22fp',
               titleSize2: '18fp',
               quoteSize: '13fp',
               fontSize: '15fp'
            })
            FontSize({
               titleSize1: '26fp',
               titleSize2: '20fp',
               quoteSize: '15fp',
               fontSize: '17fp'
            })

            Text('鸿蒙尺寸').fontSize(20).fontColor('#222')
            Divider()
               .height(1)
               .color('#999')
               .width('100%')
               .padding({
                  top: 10,
                  bottom: 10,
               })
            FontSize({
               titleSize1: '20fp',
               titleSize2: '14fp',
               quoteSize: '8fp',
               fontSize: '12fp'
            })
            FontSize({
               titleSize1: '24fp',
               titleSize2: '16fp',
               quoteSize: '10fp',
               fontSize: '14fp'
            })
            FontSize({
               titleSize1: '30fp',
               titleSize2: '18fp',
               quoteSize: '12fp',
               fontSize: '16fp'
            })

            //
            Row() {
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('black')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('white')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('gray')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
            }

            Row() {
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('red')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('green')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
               Text()
                  .layoutWeight(1)
                  .height(50)
                  .backgroundColor('blue')
                  .borderWidth(1)
                  .borderColor('#ffde663d')
            }

            Row() {
               Row().height(50).backgroundColor('gray').layoutWeight(1)
               Row().height(50).backgroundColor('blue').width(50)
            }
         }
      }.scrollable(ScrollDirection.Vertical)
   }
}*/

