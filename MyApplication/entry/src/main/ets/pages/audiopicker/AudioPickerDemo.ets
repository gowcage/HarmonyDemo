import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { activatePermission, persistPermission, PlayMusic } from './AudioPlayUtils';
import hilog from '@ohos.hilog';
import { router } from '@kit.ArkUI';
import picker from '@ohos.file.picker';
import { fileUri, fileIo as fs } from '@kit.CoreFileKit'

let TAG = 'AudioPickerDemo: gqz->'

@Entry
@Component
export struct AudioPickerDemo {
   TAG = 'AudioPickerDemo:->'
   uri =
      ["file://docs/storage/Users/currentUser/Music/%E4%B8%9C%E8%8E%9E%E4%B8%8D%E7%9B%B8%E4%BF%A1%E7%9C%BC%E6%B3%AA.mp3",
         // "file://docs/storage/Users/currentUser/Music/东莞不相信眼泪.mp3",
         "file://docs/storage/Users/currentUser/Download/%E5%91%A8%E5%8D%8E%E5%81%A5%20-%20%E7%88%B1%E7%9B%B8%E9%9A%8F.flac",
         "file://docs/storage/Users/currentUser/Documents/%E6%9D%8E%E5%AE%97%E7%9B%9B%20-%20%E5%BD%93%E7%88%B1%E5%B7%B2%E6%88%90%E5%BE%80%E4%BA%8B%E3%80%90%E6%9C%89%E9%97%B4%E9%9F%B3%E4%B9%90%E3%80%91.wav",
         "file://docs/storage/Users/currentUser/Music/Playlist_MP3/%E8%8C%83%E7%8E%AE%E7%90%AA%20-%20%E6%98%AF%E9%9D%9E%E9%A2%98.mp3"]

   aboutToAppear(): void {
      let params = router.getParams()
      hilog.debug(0, this.TAG, 'router.Params: ' + JSON.stringify(params))
   }

   build() {
      Column({ space: 20 }) {
         Button('Select Local Music').onClick(() => {
            let context = getContext(this) as common.Context; // 请确保getContext(this)返回结果为UIAbilityContext
            let audioPicker = new picker.DocumentViewPicker(context);
            audioPicker.select({
               maxSelectNumber: 500,
               authMode: true/*, fileSuffixFilters: ['mp3', 'wav', 'ape', 'flac']*/,
               multiAuthMode: true, // 支持批量授权模式, true才有全选按钮
               mergeMode: picker.MergeTypeMode.AUDIO // 仅音频文件
            })
               .then((res) => {
                  hilog.debug(0, TAG, '--------------------------------------------------------')
                  hilog.debug(0, TAG, 'get music success: uri: ' + JSON.stringify(res))
                  res.forEach((item) => {
                     hilog.debug(0, TAG, item)
                  })
                  persistPermission(res).then(() => {
                     this.uri = res
                  })
                  hilog.debug(0, TAG, '--------------------------------------------------------')
               })
               .catch((err: BusinessError) => {
                  hilog.error(0, TAG, 'slct failed: ', err)
               })
         })

         Button('Play uri').onClick(() => {
            // new AVPlayerDemo().avPlayerUrlDemo()
            hilog.debug(0, TAG, '--------------------------------------------------------')
            // PlayMusic(this.uri[0])

            // let sbPath = AppStorage.get<string>('sandBoxPath')
            // hilog.debug(0, TAG, 'sandboxPath: ' + sbPath + '   ' + fileUri.getUriFromPath(sbPath + '/test') + '   ' +
            // new fileUri.FileUri(fileUri.getUriFromPath(sbPath + '/test')).toString())

            // let js = decodeURIComponent(this.uri[0])
            // hilog.debug(0, TAG, 'decode uri: ' + js)
            let uri = this.uri[0]
            fs.open(uri).then((file) => {
               //   fs.open('file:/'+this.uri[0]).then((file) => {
               //   fs.open('file:/'+this.uri[1]).then((file) => {
               hilog.debug(0, TAG, 'open success: file.fd: ' + file.fd)
               PlayMusic('fd://' + file.fd)
            }).catch((e: BusinessError) => {
               hilog.error(0, TAG, `file打开失败 code=${e.code}, message=${e.message}, uri=${uri}`)
            })
         })
      }
      .width('100%').height('100%').justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
   }
}