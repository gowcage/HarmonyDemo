import { BuilderNode, NodeController } from "@kit.ArkUI";
import { JSON } from "@kit.ArkTS";

class MyNodeController extends NodeController {
   private buttonNode: BuilderNode<[object]> | null = null;
   private wrapBuilder: WrappedBuilder<[object]> // = wrapBuilder(myBuilder2);
   private param: object | string | number | boolean | null;

   constructor(wrapBuilder: WrappedBuilder<[object]>, param: object | string | number | boolean | null) {
      super()
      this.wrapBuilder = wrapBuilder
      this.param = param
   }

   makeNode(uiContext: UIContext): FrameNode | null {
      console.log('makeNode: ')
      if (this.buttonNode == null) {
         this.buttonNode = new BuilderNode(uiContext);
         this.buttonNode.build(this.wrapBuilder, this.param)
      }
      return this.buttonNode!.getFrameNode()!;
   }
}

// UI

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

@Builder
function myBuilder2(param: object | string | number | boolean | null) {
   Column() {
      if (typeof param === 'object') {
         Text(JSON.stringify(param)).fontSize(20).fontColor(Color.Green)
      } else if (typeof param === 'string') {
         Text(param).fontSize(20).fontColor(Color.Red)
      } else if (typeof param === 'number') {
         Text('' + param).fontSize(20).fontColor(Color.Blue)
      }
      Button('Click Me 2')

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

export class OuterTabContentNodeCtrl2<T extends Object> extends MyNodeController {
   constructor(param: T) {
      super(wrapBuilder(myBuilder2), param)
   }
}


