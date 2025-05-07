export class AudioInfo {
  name: string;
  path: string;
  size: number;
}

export const add: (a: number, b: number) => number;

export const test: (uri: string) => void;

export const getAudioInfo: (name: string, path: string, size: number) => AudioInfo;

export const registeCB: (func: (datas: object) => void) => void;

export const testCB: (num: number) => void;

export const testCBInSubThread: (func: (datas: number) => void) => void;
