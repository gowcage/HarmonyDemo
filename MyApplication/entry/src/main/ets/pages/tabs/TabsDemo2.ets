import { EncapsulationTabsBar } from './EncapsulationTabsBar';

let TAG = 'TabsDemo2: -> '

@Entry
@Component
export struct TabsDemo2 {
   build() {
      Column(){
         EncapsulationTabsBar()
      }
   }
}