import { MixedType, MyNodeController } from "./MyNodeController";

/*
 * Test UI
 * 可以添加自定义TabContentUI
 * */

@Observed
export class ObservedArray<T> extends Array<T> {
   constructor(...args: T[]) {
      super(...args);
   }
}

@Builder
function myBuilder() {
   Column() {
      Text('OuterTabContent 1')
         .fontSize(20)
         .fontColor(Color.Red)
      Button('Click Me')

   }.alignItems(HorizontalAlign.Center)
   .justifyContent(FlexAlign.Center)
   .height('100%')
   .width('100%')
}

export class OuterTabContentNodeCtrl extends MyNodeController {
   constructor() {
      super(wrapBuilder(myBuilder), null)
   }
}

@Builder
function myBuilder2(param: MixedType) {
   Column() {
      // if (typeof param === 'object') {
      //    Text(JSON.stringify(param)).fontSize(20).fontColor(Color.Green)
      // } else if (typeof param === 'string') {
      //    Text(param).fontSize(20).fontColor(Color.Red)
      // } else if (typeof param === 'number') {
      //    Text('' + param).fontSize(20).fontColor(Color.Blue)
      // }
      if (param as string) {
         if (param === '歌曲') {
            Text(param).fontSize(20).fontColor(Color.Green)
         } else if (param === '文件夹') {
            Text(param).fontSize(20).fontColor(Color.Red)
         } else if (param === '专辑') {
            Text(param).fontSize(20).fontColor(Color.Blue)
         } else if (param === '艺术家') {
            Text(param).fontSize(20).fontColor(Color.Pink)
         } else if (param === '风格') {
            Text(param).fontSize(20).fontColor(Color.Brown)
         } else if (param === '私有云') {
            Text(param).fontSize(20).fontColor(Color.Grey)
         } else if (param === '专辑艺术家') {
            Text(param).fontSize(20).fontColor(Color.Orange)
         }
      }
      Button('Click Me 2')

   }.alignItems(HorizontalAlign.Center)
   .justifyContent(FlexAlign.Center)
   .height('100%')
   .width('100%')
}

export class OuterTabContentNodeCtrl2<T extends MixedType> extends MyNodeController {
   constructor(param: T) {
      super(wrapBuilder(myBuilder2), param)
   }
}


