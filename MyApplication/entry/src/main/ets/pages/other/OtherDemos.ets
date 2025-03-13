import { hilog } from "@kit.PerformanceAnalysisKit"

let TAG = 'OtherDemos: gqz->'

@Entry
@Component
export struct OtherDemos {
   aboutToAppear(): void {
   }

   build() {
      Column({ space: 20 }) {
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
   }
}

