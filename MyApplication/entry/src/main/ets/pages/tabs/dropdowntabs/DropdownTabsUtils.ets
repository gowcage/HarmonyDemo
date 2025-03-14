import { BuilderNode, NodeController } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

export enum ContentType {
   TYPE_DEFAULT = 0,
   TYPE_TABCONTENT,
   TYPE_DROPDOWN
}

export interface TabsContent {
   type: ContentType
   name: string
   nodeCtrl: MyNodeController
}

export type MixedType =
   | string      // 字符串
   | number      // 数字
   | boolean     // 布尔
   | null        // null
   | undefined   // undefined
   | bigint      // 大整数
   | object      // 非原始类型（对象、数组、函数等）

export class MyNodeController extends NodeController {
   private TAG = 'MyNodeController: ->'
   private buttonNode: BuilderNode<[object]> | null = null;
   public  wrapBuilder: WrappedBuilder<[object]>
   private param: MixedType;

   constructor(wrapBuilder: WrappedBuilder<[object]>, param: MixedType) {
      super()
      this.wrapBuilder = wrapBuilder
      this.param = param
   }

   makeNode(uiContext: UIContext): FrameNode | null {
      hilog.debug(0, this.TAG, 'makeNode:')
      if (this.buttonNode == null) {
         this.buttonNode = new BuilderNode(uiContext);
         this.buttonNode.build(this.wrapBuilder, this.param)
      }
      return this.buttonNode!.getFrameNode()!;
   }
}
