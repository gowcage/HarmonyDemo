import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi, { AudioInfo, test } from 'libentry.so';
import { AudioInfo as aInfo } from './AudioInfo'

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
   TAG = 'hiby: Index'
   @State message: string = 'Hello World';

   aboutToAppear(): void {
      testNapi.registeCB((datas: object) => {
         hilog.debug(0, this.TAG, 'native call arkts: %{public}s', JSON.stringify(datas))
      })
   }

   build() {
      Row() {
         Column({ space: 20 }) {
            Text(this.message)
               .fontSize($r('app.float.page_text_font_size'))
               .fontWeight(FontWeight.Bold)
               .onClick(() => {
                  // this.message = 'Welcome';
                  // hilog.info(DOMAIN, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
                  // let info: AudioInfo =
                  //    testNapi.getAudioInfo('火力全开.mp3', '/storage/sdcard/Download/火力全开.mp3', 120)
                  // let ainfo: aInfo = info as aInfo
                  // hilog.debug(0, this.TAG, `${JSON.stringify(ainfo)}`)
               })
            Button('Test Callback 1')
               .onClick(() => {
                  testNapi.testCB(1);
               })
            Button('Test Callback 2')
               .onClick(() => {
                  testNapi.testCB(2);
               })
            Button('Test Callback 3')
               .onClick(() => {
                  testNapi.testCB(3);
               })
            Button('Test Callback 4')
               .onClick(() => {
                  testNapi.testCBInSubThread((data: number) => {
                     hilog.debug(0, this.TAG, 'testCBInSubThread: %{public}s', JSON.stringify(data))
                  });
               })
         }
         .width('100%')
      }
      .height('100%')
   }
}
