import type HapticPattern from './haptic_pattern_type';
declare type HapticEngineType = {
    getSupportsHaptics(): Promise<boolean>;
    startPlayerAtTime(startTime: number): Promise<void>;
    create(): Promise<boolean>;
    makePlayer(pattern: typeof HapticPattern): Promise<boolean>;
    start(): Promise<void>;
    stop(): Promise<void>;
};
declare const _default: HapticEngineType;
export default _default;
