export default defineAppConfig({
  ui: {
    primary: 'emerald',
    secondary: 'fuchsia',
    neutral: 'gray',
    warning: 'yellow',

    slideover: {
      slots: {
        overlay: 'fixed inset-0 bg-elevated/75 bg-gray-300/70 dark:bg-gray-800/90',
        content: 'fixed bg-gray-100 dark:bg-gray-900 divide-y divide-default sm:ring ring-default sm:shadow-lg flex flex-col focus:outline-none',
        header: 'flex items-center gap-1.5 p-4 mt-20 sm:px-6 dark:text-gray-200 text-black min-h-16',
        wrapper: '',
        body: 'flex-1 overflow-y-auto dark:text-gray-200 text-black p-4 sm:p-6',
        footer: 'flex items-center gap-1.5 p-4 sm:px-6',
        title: 'text-highlighted font-semibold',
        description: 'mt-1 text-muted text-sm',
        close: 'absolute top-26 end-12 text-lg cursor-pointer bg-green-500 p-1'
      },
      variants: {
        side: {
          top: {
            content: 'inset-x-0 top-0 max-h-full'
          },
          right: {
            content: 'right-0 inset-y-0 w-full max-w-md'
          },
          bottom: {
            content: 'inset-x-0 bottom-0 max-h-full'
          },
          left: {
            content: 'left-0 inset-y-0 w-full max-w-md'
          }
        },
        transition: {
          true: {
            overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]'
          }
        }
      },
      compoundVariants: [
        {
          transition: true,
          side: 'top',
          class: {
            content: 'data-[state=open]:animate-[slide-in-from-top_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-top_200ms_ease-in-out]'
          }
        },
        {
          transition: true,
          side: 'right',
          class: {
            content: 'data-[state=open]:animate-[slide-in-from-right_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-right_200ms_ease-in-out]'
          }
        },
        {
          transition: true,
          side: 'bottom',
          class: {
            content: 'data-[state=open]:animate-[slide-in-from-bottom_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-bottom_200ms_ease-in-out]'
          }
        },
        {
          transition: true,
          side: 'left',
          class: {
            content: 'data-[state=open]:animate-[slide-in-from-left_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-left_200ms_ease-in-out]'
          }
        }
      ]
    },

    drawer: {
      slots: {
        overlay: 'fixed inset-0 bg-elevated/75',
        content: 'fixed bg-gray-100 dark:bg-gray-900 min-w-[30vw] ring ring-default flex focus:outline-none',
        handle: [
          'shrink-0 !bg-accented',
          'transition-opacity'
        ],
        container: 'w-full flex flex-col gap-4 p-4 overflow-y-auto',
        header: '',
        title: 'text-highlighted font-semibold',
        description: 'mt-1 text-muted text-sm',
        body: 'flex-1 pt-20',
        footer: 'flex flex-col gap-1.5'
      },
      variants: {
        direction: {
          top: {
            content: 'mb-24 flex-col-reverse',
            handle: 'mb-4'
          },
          right: {
            content: 'flex-row',
            handle: '!ml-4'
          },
          bottom: {
            content: 'mt-24 flex-col',
            handle: 'mt-4'
          },
          left: {
            content: 'flex-row-reverse',
            handle: '!mr-4'
          }
        },
        inset: {
          true: {
            content: 'rounded-lg after:hidden'
          }
        }
      },
      compoundVariants: [
        {
          direction: [
            'top',
            'bottom'
          ],
          class: {
            content: 'h-auto max-h-[96%]',
            handle: '!w-12 !h-1.5 mx-auto'
          }
        },
        {
          direction: [
            'right',
            'left'
          ],
          class: {
            content: 'w-auto max-w-[calc(100%-2rem)]',
            handle: '!h-12 !w-1.5 mt-auto mb-auto'
          }
        },
        {
          direction: 'top',
          inset: true,
          class: {
            content: 'inset-x-4 top-4'
          }
        },
        {
          direction: 'top',
          inset: false,
          class: {
            content: 'inset-x-0 top-0 rounded-b-lg'
          }
        },
        {
          direction: 'bottom',
          inset: true,
          class: {
            content: 'inset-x-4 bottom-4'
          }
        },
        {
          direction: 'bottom',
          inset: false,
          class: {
            content: 'inset-x-0 bottom-0 rounded-t-lg'
          }
        },
        {
          direction: 'left',
          inset: true,
          class: {
            content: 'inset-y-4 left-4'
          }
        },
        {
          direction: 'left',
          inset: false,
          class: {
            content: 'inset-y-0 left-0 rounded-r-lg'
          }
        },
        {
          direction: 'right',
          inset: true,
          class: {
            content: 'inset-y-4 right-4'
          }
        },
        {
          direction: 'right',
          inset: false,
          class: {
            content: 'inset-y-0 right-0 rounded-l-lg'
          }
        }
      ]
    },
    modal: {
      slots: {
        overlay: 'fixed inset-0 bg-gray-800/90',
        content: 'fixed divide-y divide-default flex flex-col focus:outline-none dark:bg-gray-900 bg-gray-100 dark:text-white',
        header: 'flex items-center gap-1.5 p-4 sm:px-6 min-h-16 dark:bg-gray-900 bg-gray-100',
        wrapper: '',
        body: 'flex-1 overflow-y-auto p-4 sm:p-6 dark:bg-gray-900 bg-gray-100',
        footer: 'flex items-center gap-1.5 p-4 sm:px-6 dark:bg-gray-900 bg-gray-100',
        title: 'text-highlighted font-semibold',
        description: 'mt-1 text-muted text-sm',
        close: 'absolute top-6 end-4 cursor-pointer'
      },
      variants: {
        transition: {
          true: {
            overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]',
            content: 'data-[state=open]:animate-[scale-in_200ms_ease-out] data-[state=closed]:animate-[scale-out_200ms_ease-in]'
          }
        },
        fullscreen: {
          true: {
            content: 'inset-0'
          },
          false: {
            content: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[calc(100vw-2rem)] max-w-lg max-h-[calc(100dvh-2rem)] sm:max-h-[calc(100dvh-4rem)] rounded-lg shadow-lg ring ring-default'
          }
        }
      }
    },
    
    carousel: {
      slots: {
        root: 'relative focus:outline-none',
        viewport: 'overflow-hidden',
        container: 'flex items-start',
        item: 'min-w-0 shrink-0 basis-full',
        controls: '',
        arrows: '',
        prev: 'absolute rounded-full',
        next: 'absolute rounded-full',
        dots: 'absolute inset-x-0 -bottom-7 flex flex-wrap items-center justify-center gap-3',
        dot: [
          'cursor-pointer size-3 bg-accented rounded-full',
          'transition'
        ]
      },
      variants: {
        orientation: {
          vertical: {
            container: 'flex-col -mt-4',
            item: 'pt-4',
            prev: 'top-4 sm:-top-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90',
            next: 'bottom-4 sm:-bottom-12 left-1/2 -translate-x-1/2 rotate-90 rtl:-rotate-90'
          },
          horizontal: {
            container: 'flex-row -ms-4',
            item: 'ps-4',
            prev: 'start-4 sm:-start-12 top-1/2 -translate-y-1/2',
            next: 'end-4 sm:-end-12 top-1/2 -translate-y-1/2'
          }
        },
        active: {
          true: {
            dot: 'data-[state=active]:bg-inverted'
          }
        }
      }
    },

    avatar: {
      slots: {
        root: 'inline-flex items-center justify-center shrink-0 select-none rounded-full align-middle bg-elevated',
        image: 'h-full w-full rounded-[inherit] object-cover',
        fallback: 'font-medium leading-none text-muted truncate',
        icon: 'text-muted shrink-0'
      },
      variants: {
        size: {
          '3xs': {
            root: 'size-4 text-[8px]'
          },
          '2xs': {
            root: 'size-5 text-[10px]'
          },
          xs: {
            root: 'size-6 text-xs'
          },
          sm: {
            root: 'size-7 text-sm'
          },
          md: {
            root: 'size-8 text-base'
          },
          lg: {
            root: 'size-9 text-lg'
          },
          xl: {
            root: 'size-10 text-xl'
          },
          '2xl': {
            root: 'size-11 text-[22px]'
          },
          '3xl': {
            root: 'size-12 text-2xl'
          }
        }
      },
      defaultVariants: {
        size: 'md'
      }
    },
  }
})
