# Minimal Neovim PDE for Java development

This repository contains an example

Plugins used:
 - [Lazy.nvim](https://github.com/folke/lazy.nvim): Plugin manager
 - [Mason.nvim](https://github.com/williamboman/mason.nvim): Package manager
 - [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls): Language Server Client
 - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp): Completion engine, depends on:
    - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp): Extension to nvim-cmp to provide LSP completion
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip): Snippet engine necessary for nvim-cmp
 - [neotest](https://github.com/nvim-neotest/neotest): Test runner with user interface, depends on:
    - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim): General utilities for neovim development
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): Syntax tree parser
    - [neotest-java](https://github.com/rcasia/neotest-java): Neotest adapter for Java tests
 - [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui): Interface for debugging, depends on:
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap): Debug Adapter Client

Packages used:
 - [Eclipse's JDT Language Sever](https://github.com/eclipse-jdtls/eclipse.jdt.ls): Language Server for Java, based on the JDT toolkit
 - [Java Debug](https://github.com/microsoft/java-debug): Java Debug Server
 - [Java Test](https://github.com/microsoft/vscode-java-test): Test runner for Java
 - [Lombok](https://projectlombok.org/)(optional): Adds Lombok suport to your language server

### Prerequisites

 - You know what a table is in lua, how to declare variables and functions (c'mon, the basics)
 - You understand how your plugin manager works
 - 

## Quick start

Index
 1. Install the package manager
 2. Setup a Language Server
 3. Add Lombok Support (optional)
 4. Get code completion
 5. Run tests
 6. Debug code
 7. Debug tests

### 1. Install the package manager

[Mason.nvim](https://github.com/williamboman/mason.nvim) is a package manager
that will allow us to install all the necessary binaries without leaving Neovim.
Installation is straight forward, just follow the [installation
instructions](https://github.com/williamboman/mason.nvim?tab=readme-ov-file#installation)
availabe in its repository.

```lua
-- Lazy.nvim configuration
{
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonLog', 'MasonInstall' },
    opts = {},
}
```

To ensure it is properly wroking you can invoke the command `:Mason`, you should
see a window pop up. There's also a `:MasonLog` command to see logs if you run
into any issues.

### 2. Setup a Language Server

This step used to be complicated but it has become very simple, the problem is
that old and outdated documentation still exists and can cause confusion for
newcomers.

To get started we use Mason to install [Eclipse's JDT Language Server](https://github.com/eclipse-jdtls/eclipse.jdt.ls)
with `:MasonInstall jdtls`, and the fantastic [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
plugin. 

```lua
-- Lazy.nvim configuration
{
    'mfussenegger/nvim-jdtls',
    ft = 'java',
}
```

To set it up we need to call `start_or_attach` function whenever we open a java
file, this can be achieved with an autocmd or (my favorite) a file `java.lua`
inside `ftplugin/` directory. This function takes a table with the **cmd**
property to tell it how to start the language server. If you've installed it
using Mason, an executable file will be located in `$HOME/.local/share/nvim/mason/bin/jdtls`.

```lua
-- ftplugin/java.lua
require'jdtls'.start_or_attach({
    cmd = {
        vim.fn.expand'$HOME/.local/share/nvim/mason/bin/jdtls',
    }
})
```

 > Note: Python3 and Java 17+ is required for JDT.LS to work

### 3. Add Lombok Support (optional)

If your projects use Lombok you need to add it as a javaagent to JDTLS,
that is done by adding `-javaagent` flag pointing to the location of
`lombok.jar`. If you used Mason.nvim, it already came with your JDTLS
instalation. Update nvim-jdtls configuration to look like this:

```patch
 require'jdtls'.start_or_attach({
     cmd = {
         vim.fn.expand'$HOME/.local/share/nvim/mason/bin/jdtls',
+        ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand'$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar')
     }
 })
```

### 4. Get code completion
### 5. Run tests
### 6. Debug code
### 7. Debug tests

## Package Manager (Mason)

 1. Install `williamboman/mason.nvim`
 2. Test comand `:Mason`

## Syntax highlighting

 1. Install `nvim-treesitter/nvim-treesitter`
 2. Call setup with the following opts
 ```lua
 require'nvim-treesitter.configs'.setup{
	 ensure_installed = 'java',
	 highlight = { enable = true },
	 indent = { enable = true },
 }
 ```
 3. Install treesitter-cli `:MasonInstall tree-sitter-cli`

## LSP and error checking

 1. Install jdtls `:MasonInstall jdtls`
 2. Ensure `jdtls` is a valid command
     - mason.nvim should add its install location to your path, if not then it's likely gonna be `~/.local/share/nvim/mason/bin`
     - ensure it runs with your default java version
 3. Expect the following output
 ```
[root@8f8e826c0e18 nvim]# ~/.local/share/nvim/mason/bin/jdtls 
WARNING: Using incubator modules: jdk.incubator.foreign, jdk.incubator.vector
Feb 10, 2024 12:33:29 AM org.apache.aries.spifly.BaseActivator log
INFO: Registered provider ch.qos.logback.classic.servlet.LogbackServletContainerInitializer of service jakarta.servlet.ServletContainerInitializer in bundle ch.qos.logback.classic
Feb 10, 2024 12:33:29 AM org.apache.aries.spifly.BaseActivator log
INFO: Registered provider ch.qos.logback.classic.spi.LogbackServiceProvider of service org.slf4j.spi.SLF4JServiceProvider in bundle ch.qos.logback.classic
```
 4. Install and setup nvim-jdtls
     - In a file that only loads when java `ftplugin/java.lua` for example
     ```
     require'jdtls'.start_or_attach{
	     cmd = { vim.fn.expand'$HOME/.local/share/nvim/mason/bin/jdtls' }
     }
     ```
 5. Add lombok support by adding the javaagent, already comes with the jdtls downloaded with mason
     ```
     require'jdtls'.start_or_attach{
	     cmd = {
		     vim.fn.expand'$HOME/.local/share/nvim/mason/bin/jdtls',
		     ('--jvm-arg=-javaagent:%s'):format(vim.fn.expand'$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar')
	     }
     }
     ```

## Autocompletion

 - hrsh7th/nvim-cmp
 - luasnip

## Running tests

 - Make sure to install java parser `:TSInstall java`
 - Logs at `~/.local/state/nvim/neotest.log`

New commands:
 - require('neotest').run.run(vim.fn.expand('%'))
 - require('neotest').run.run(vim.loop.cwd())
 - require('neotest').run.run()
 - require('neotest').summary.toggle()
 - require('neotest').output.open({ enter = true, auto_close = true })
 - require('neotest').output_panel.toggle()
 - require('neotest').run.stop()

## Debbugging

For debugging we will be using a combination of nvim-dap and nvim-jdtls

 1. Run `:MasonInstall java-debug-adapter`
 2. Add the bundles to jdlts
 3. Install dap
 4. Call `:JdtUpdateDebugConfigs` on your project once the language server has loaded
 5. New commands available
 ```
"""DEBUG COMMANDS"""
command! DebugToggleBreakpoint lua require'dap'.toggle_breakpoint()
command! DebugContinue lua require'dap'.continue()
command! DebugStepOver lua require'dap'.step_over()
command! DebugStepInto lua require'dap'.step_into()
command! DebugInspect lua require'dap'.repl.open()
command! DebugRestart lua require'dap'.restart()
command! DebugClose lua require'dap'.close()
command! DebugEval lua require'dapui'.eval()
command! DebugToggle lua require'dapui'.toggle()

 ```

## Debug testst

 1. Instal `:MasonInstall java-test`

