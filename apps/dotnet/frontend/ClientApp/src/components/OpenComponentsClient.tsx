import React from "react";
import Helmet from "react-helmet";

declare global {
  interface Window {
    oc: {
      cmd: Array<() => void>;
      conf: {
        templates: Array<{
          type: string;
          externals: Array<{ global: string; url: string }>;
        }>;
      };
    };
  }
}

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace JSX {
    interface IntrinsicElements {
      "oc-component": React.DetailedHTMLProps<
        React.HTMLAttributes<HTMLElement> & { href: string },
        HTMLElement
      >;
    }
  }
}

const OpenComponentsClient: React.FC<{
  reactVersion?: string;
  ocOrigin?: string;
}> = ({ reactVersion = "16.13.1", ocOrigin = "" }) => {
  if (!window.oc) {
    window.oc = window.oc || {};
    window.oc.cmd = window.oc.cmd || [];
    window.oc.conf = window.oc.conf || {};

    window.oc.conf.templates = window.oc.conf.templates || [];
    window.oc.conf.templates = window.oc.conf.templates.concat([
      {
        type: "oc-template-typescript-react",
        externals: [
          {
            global: "React",
            url: `https://unpkg.com/react@${reactVersion}/umd/react.production.min.js`,
          },
          {
            global: "ReactDOM",
            url: `https://unpkg.com/react-dom@${reactVersion}/umd/react-dom.production.min.js`,
          },
        ],
      },
    ]);
  }

  return (
    <Helmet>
      <script src={`${ocOrigin}/oc-client/client.js`} />
    </Helmet>
  );
};

export default OpenComponentsClient;
