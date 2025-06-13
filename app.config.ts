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


    badge: {
      slots: {
        base: 'font-medium inline-flex items-center',
        label: 'truncate',
        leadingIcon: 'shrink-0',
        leadingAvatar: 'shrink-0',
        leadingAvatarSize: '',
        trailingIcon: 'shrink-0'
      },
      variants: {
        buttonGroup: {
          horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',
          vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'
        },
        color: {
          primary: 'blue',       // used for primary actions (buttons, highlights)
          secondary: 'violet',   // secondary accents or alternative actions
          success: 'emerald',    // success messages or indicators
          info: 'sky',           // informative notes or tooltips
          warning: 'amber',      // warnings like "are you sure?" messages
          error: 'rose',         // error alerts, validations
          neutral: 'zinc'        // base gray-like colors for backgrounds, text
        },

        variant: {
          solid: 'bg-{color}-500 text-white border-transparent',
          outline: 'bg-transparent border border-{color}-500 text-{color}-500',
          soft: 'bg-{color}-100 text-{color}-800 border border-transparent',
          subtle: 'bg-{color}-50 text-{color}-700 border border-transparent'
        },
        size: {
          xs: {
            base: 'text-[8px]/3 px-1 py-0.5 gap-1 rounded-sm',
            leadingIcon: 'size-3',
            leadingAvatarSize: '3xs',
            trailingIcon: 'size-3'
          },
          sm: {
            base: 'text-[10px]/3 px-1.5 py-1 gap-1 rounded-sm',
            leadingIcon: 'size-3',
            leadingAvatarSize: '3xs',
            trailingIcon: 'size-3'
          },
          md: {
            base: 'text-xs px-2 py-1 gap-1 rounded-md',
            leadingIcon: 'size-4',
            leadingAvatarSize: '3xs',
            trailingIcon: 'size-4'
          },
          lg: {
            base: 'text-sm px-2 py-1 gap-1.5 rounded-md',
            leadingIcon: 'size-5',
            leadingAvatarSize: '2xs',
            trailingIcon: 'size-5'
          },
          xl: {
            base: 'text-base px-2.5 py-1 gap-1.5 rounded-md',
            leadingIcon: 'size-6',
            leadingAvatarSize: '2xs',
            trailingIcon: 'size-6'
          }
        },
        square: {
          true: ''
        }
      },
      compoundVariants: [
        {
          color: 'primary',
          variant: 'solid',
          class: 'bg-primary text-inverted'
        },
        {
          color: 'primary',
          variant: 'outline',
          class: 'text-primary ring ring-inset ring-primary/50'
        },
        {
          color: 'primary',
          variant: 'soft',
          class: 'bg-primary/10 text-primary'
        },
        {
          color: 'primary',
          variant: 'subtle',
          class: 'bg-primary/10 text-primary ring ring-inset ring-primary/25'
        },
        {
          color: 'neutral',
          variant: 'solid',
          class: 'text-inverted bg-inverted'
        },
        {
          color: 'neutral',
          variant: 'outline',
          class: 'ring ring-inset ring-accented text-default bg-default'
        },
        {
          color: 'neutral',
          variant: 'soft',
          class: 'text-default bg-elevated'
        },
        {
          color: 'neutral',
          variant: 'subtle',
          class: 'ring ring-inset ring-accented text-default bg-elevated'
        },
        {
          size: 'xs',
          square: true,
          class: 'p-0.5'
        },
        {
          size: 'sm',
          square: true,
          class: 'p-1'
        },
        {
          size: 'md',
          square: true,
          class: 'p-1'
        },
        {
          size: 'lg',
          square: true,
          class: 'p-1'
        },
        {
          size: 'xl',
          square: true,
          class: 'p-1'
        }
      ],
      defaultVariants: {
        color: 'primary',
        variant: 'solid',
        size: 'md'
      }
    },

    dropdownMenu: {
      slots: {
        content: 'min-w-32 bg-gray-100 dark:bg-gray-900 dark:text-gray-300 shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-dropdown-menu-content-transform-origin) flex flex-col',
        viewport: 'relative divide-y divide-default scroll-py-1 overflow-y-auto flex-1',
        arrow: 'fill-default',
        group: 'p-1 isolate',
        label: 'w-full flex items-center font-semibold text-highlighted',
        separator: '-mx-1 my-1 h-px bg-border',
        item: 'group relative w-full flex items-center select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',
        itemLeadingIcon: 'shrink-0',
        itemLeadingAvatar: 'shrink-0',
        itemLeadingAvatarSize: '',
        itemTrailing: 'ms-auto inline-flex gap-1.5 items-center',
        itemTrailingIcon: 'shrink-0',
        itemTrailingKbds: 'hidden lg:inline-flex items-center shrink-0',
        itemTrailingKbdsSize: '',
        itemLabel: 'truncate',
        itemLabelExternalIcon: 'inline-block size-3 align-top text-dimmed'
      },
      variants: {
        color: {
          primary: '',
          secondary: '',
          success: '',
          info: '',
          warning: '',
          error: '',
          neutral: ''
        },
        active: {
          true: {
            item: 'text-highlighted before:bg-elevated',
            itemLeadingIcon: 'text-default'
          },
          false: {
            item: [
              'text-default data-highlighted:text-highlighted data-[state=open]:text-highlighted data-highlighted:before:bg-elevated/50 data-[state=open]:before:bg-elevated/50',
              'transition-colors before:transition-colors'
            ],
            itemLeadingIcon: [
              'text-dimmed group-data-highlighted:text-default group-data-[state=open]:text-default',
              'transition-colors'
            ]
          }
        },
        loading: {
          true: {
            itemLeadingIcon: 'animate-spin'
          }
        },
        size: {
          xs: {
            label: 'p-1 text-xs gap-1',
            item: 'p-1 text-xs gap-1',
            itemLeadingIcon: 'size-4',
            itemLeadingAvatarSize: '3xs',
            itemTrailingIcon: 'size-4',
            itemTrailingKbds: 'gap-0.5',
            itemTrailingKbdsSize: 'sm'
          },
          sm: {
            label: 'p-1.5 text-xs gap-1.5',
            item: 'p-1.5 text-xs gap-1.5',
            itemLeadingIcon: 'size-4',
            itemLeadingAvatarSize: '3xs',
            itemTrailingIcon: 'size-4',
            itemTrailingKbds: 'gap-0.5',
            itemTrailingKbdsSize: 'sm'
          },
          md: {
            label: 'p-1.5 text-sm gap-1.5',
            item: 'p-1.5 text-sm gap-1.5',
            itemLeadingIcon: 'size-5',
            itemLeadingAvatarSize: '2xs',
            itemTrailingIcon: 'size-5',
            itemTrailingKbds: 'gap-0.5',
            itemTrailingKbdsSize: 'md'
          },
          lg: {
            label: 'p-2 text-sm gap-2',
            item: 'p-2 text-sm gap-2',
            itemLeadingIcon: 'size-5',
            itemLeadingAvatarSize: '2xs',
            itemTrailingIcon: 'size-5',
            itemTrailingKbds: 'gap-1',
            itemTrailingKbdsSize: 'md'
          },
          xl: {
            label: 'p-2 text-base gap-2',
            item: 'p-2 text-base gap-2',
            itemLeadingIcon: 'size-6',
            itemLeadingAvatarSize: 'xs',
            itemTrailingIcon: 'size-6',
            itemTrailingKbds: 'gap-1',
            itemTrailingKbdsSize: 'lg'
          }
        }
      },
      compoundVariants: [
        {
          color: 'primary',
          active: false,
          class: {
            item: 'text-primary data-highlighted:text-primary data-highlighted:before:bg-primary/10 data-[state=open]:before:bg-primary/10',
            itemLeadingIcon: 'text-primary/75 group-data-highlighted:text-primary group-data-[state=open]:text-primary'
          }
        },
        {
          color: 'primary',
          active: true,
          class: {
            item: 'text-primary before:bg-primary/10',
            itemLeadingIcon: 'text-primary'
          }
        }
      ],
      defaultVariants: {
        size: 'md'
      }
    }
  }
})
