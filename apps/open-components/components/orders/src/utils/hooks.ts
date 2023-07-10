import { useCallback, useEffect, useLayoutEffect, useRef } from "react";

export const useStaticCallback = (
  handler: (...args: unknown[]) => void,
  dependencies: unknown[]
) => {
  const handlerRef = useRef(handler);
  // we need an immutable callback object in order to correctly unsubscribe from the event
  const callback = useCallback((...data: unknown[]) => {
    handlerRef.current(...data);
  }, []);

  useLayoutEffect(() => {
    handlerRef.current = handler;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, dependencies);

  return callback;
};

export const useAsyncEffect = (
  effect: () => Promise<void | (() => void)>,
  deps: React.DependencyList | undefined
) => {
  return useEffect(() => {
    const promise = effect();
    return () => {
      promise.then((dispose) => dispose && dispose());
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
};
