import { Book } from "./CustomComp"


@Component
export struct CompB {
   @Consume pageinfo: Book

   build() {
      Column() {
         Text('CompB ' + this.pageinfo.toString()).fontSize(20).fontColor('black')
      }
   }
}

@Builder
function CompBBuilder() {
   CompB()
}

export let wrapCompB: WrappedBuilder<[]> = wrapBuilder(CompBBuilder)

@Component
export struct CompC {
   @Consume pageinfo: Book

   build() {
      Column() {
         Text('CompC ' + this.pageinfo.toString()).fontSize(20).fontColor('black')
      }
   }
}

@Builder
function CompCBuilder() {
   CompC()
}

export let wrapCompC: WrappedBuilder<[]> = wrapBuilder(CompCBuilder)