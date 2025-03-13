import { media } from '@kit.MediaKit';
import { fileIo, fileIo as fs, fileShare } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { audio } from '@kit.AudioKit';
import hilog from '@ohos.hilog';

@Component
export struct AudioPlayUtils {
  build() {
  }
}

let TAG = 'AudioPlayUtils: gqz->'

let _player: media.AVPlayer | null = null

export function PlayMusic(uri: string) {
  media.createAVPlayer().then(async player => {
    hilog.debug(0, TAG, 'createAVPlayer success: ' + player)
    _player = player
    player.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      hilog.debug(0, TAG, '--------------------------------------------------------')
      hilog.debug(0, TAG, 'state:%s,  reason:%d', state, reason)
      switch (state) {
        case 'initialized':
          player.prepare().then(() => {
            hilog.debug(0, TAG, 'prepare success: ')
          }).catch((err: BusinessError) => {
            hilog.debug(0, TAG, `avPlayer prepare failed, code is ${err.code}, message is ${err.message}`)
          })
        case 'prepared':
          player.play().then(() => {
            hilog.debug(0, TAG, 'play success: ')
          }).catch((err: BusinessError) => {
            hilog.debug(0, TAG, `avPlayer play failed, code is ${err.code}, message is ${err.message}`)
          })
      }
    })

    player.on('error', (err: BusinessError) => {
      hilog.debug(0, TAG, '--------------------------------------------------------')
      hilog.debug(0, TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`)
      player.reset()
    })

    hilog.debug(0, TAG, '--------------------------------------------------------')
    // hilog.debug(0, TAG, 'file fd: ' + file.fd)
    player.url = uri

  }).catch((err: BusinessError) => {
    hilog.debug(0, TAG, 'createAVPlayer failed with err: ' + JSON.stringify(err))
    if (_player) {
      _player.release()
    }
  }).finally(() => {
  })
}

export function stopPlay() {
  if (_player) {
    _player.stop().then(() => {
      hilog.debug(0, TAG, 'stop success: ')
    }).catch((err: BusinessError) => {
      hilog.debug(0, TAG, `avPlayer stop failed, code is ${err.code}, message is ${err.message}`)
      _player?.release()
    })
  }
}

/*
 * 通过系统的Picker选择文件返回的uri[]，给予uri[]永久授权，
 * 首次通过fileShare.persistPermission获取永久授权成功后，可获取本次app运行时的临时访问权限
 * 以后每次启动app需要先通过fileShare.activatePermission激活访问权限
 * 因此需要存储uri[]以供activatePermission激活
 *
 * e.g. uri = file://docs/storage/Users/currentUser/Music/%E4%B8%9C%E8%8E%9E%E4%B8%8D%E7%9B%B8%E4%BF%A1%E7%9C%BC%E6%B3%AA.mp3
 * */

export async function persistPermission(uris: string[]) {
  try {
    let policyInfo: fileShare.PolicyInfo = {
      uri: uris[0],
      operationMode: fileShare.OperationMode.READ_MODE,
    }
    let policies: Array<fileShare.PolicyInfo> = [policyInfo]
    fileShare.persistPermission(policies).then(() => {
      hilog.debug(0, TAG, "persistPermission successfully")
    }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
      hilog.debug(0, TAG, "persistPermission failed with error message: " + err.message + ", error code: " + err.code)
      if (err.code == 13900001 && err.data) {
        for (let i = 0; i < err.data.length; i++) {
          hilog.debug(0, TAG, "error code : " + JSON.stringify(err.data[i].code))
          hilog.debug(0, TAG, "error uri : " + JSON.stringify(err.data[i].uri))
          hilog.debug(0, TAG, "error reason : " + JSON.stringify(err.data[i].message))
        }
      }
    })
  } catch (error) {
    let err: BusinessError = error as BusinessError
    hilog.debug(0, TAG, 'persistPermission failed with err: ' + JSON.stringify(err))
  }
}

export function activatePermission(uris: string[]) {
  hilog.debug(0, TAG, "----------------------------------")
  let policyInfo: fileShare.PolicyInfo = {
    uri: uris[0], operationMode: fileShare.OperationMode.READ_MODE,
  }
  let policies: Array<fileShare.PolicyInfo> = [policyInfo]

  fileShare.activatePermission(policies).then(() => {
    hilog.debug(0, TAG, "activatePermission successfully")

  }).catch(async (err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
    hilog.error(0, TAG, "activatePermission failed with error message: " + err.message + ", error code: " + err.code)
    if (err.code == 13900001 && err.data) {
      for (let i = 0; i < err.data.length; i++) {
        hilog.error(0, TAG, "error code : " + JSON.stringify(err.data[i].code))
        hilog.error(0, TAG, "error uri : " + JSON.stringify(err.data[i].uri))
        hilog.error(0, TAG, "error reason : " + JSON.stringify(err.data[i].message))
        if (err.data[i].code == fileShare.PolicyErrorCode.PERMISSION_NOT_PERSISTED) {
          await fileShare.persistPermission(policies)
        }
      }
    }
  })
}
