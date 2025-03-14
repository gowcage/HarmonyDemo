import { OuterTabContentNodeCtrl } from "../tabs/dropdowntabs/CustomTabContents"
import { MixedType, MyNodeController } from "../tabs/dropdowntabs/DropdownTabsUtils"
import { JSON } from "@kit.ArkTS"
import { wrapCompB, wrapCompC } from "./WrapBuilders"

export class Book {
   name: string = 'def book name'

   constructor(name: string) {
      this.name = name
   }

   toString(): string {
      return JSON.stringify(this)
   }
}

@Builder
function CompBBuilder() {
   CompB()
}

let a = wrapBuilder(CompBBuilder)

class NodeCtrl extends MyNodeController {
   constructor() {
      super(wrapBuilder(CompBBuilder), undefined)
   }
}

@Component
export struct CompA {
   @Consume pageinfo: Book

   build() {
      Column() {
         Text('CompA ' + this.pageinfo.toString()).fontSize(20).fontColor('black')
         // NodeContainer(new NodeCtrl())
         // CompBBuilder()
         wrapCompB.builder()
         wrapCompC.builder()
         new NodeCtrl().wrapBuilder.builder(undefined)
      }
   }
}

@Component
export struct CompB {
   @Consume pageinfo: Book

   build() {
      Column() {
         Text('CompB ' + this.pageinfo.toString()).fontSize(20).fontColor('black')
      }
   }
}