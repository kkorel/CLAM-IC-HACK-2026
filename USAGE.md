# Clam.sh Usage

*Note*. You might need to prefix each of these commands with `source`, e.g. `source clam enable`.

1. **Display Help Information**  

   ```bash
   clam --help
   ```  

   *Check that the help text is clear and lists all available commands.*

2. **Install the Script**  

   ```bash
   clam install
   ```  

   *This adds the necessary lines to your ~/.bashrc and sets up the environment.*

3. **Reload Your Shell**  

   ```bash
   source ~/.bashrc
   ```  

   *Reload your bash configuration to activate Clam.sh.*

4. **Show Current Configuration**  

   ```bash
   clam config
   ```  

   *Verify that your configuration (including API keys, model settings, etc.) is loaded correctly.*

5. **Update a Configuration Value**  

   ```bash
   clam config set temperature 0.5
   ```  

   *Change the temperature setting to test the config update and then run `clam config` again to confirm the change.*

6. **Display Usage Statistics**  

   ```bash
   clam usage
   ```  

   *View log and cost metrics as well as cache information.*

7. **Display System Information**  

   ```bash
   clam system
   ```  

   *Ensure that system and terminal details are being reported correctly.*

8. **Test Command Completion (Dry Run)**  

   ```bash
   clam command --dry-run "ls -la"
   ```  

   *Run a dry-run to see the generated prompt and suggestions without executing any real command.*

9. **Interact with the Model Selection Menu**  

   ```bash
   clam model
   ```  

   *This will open an interactive menu—use your arrow keys to navigate and press Enter to select a model (or press “q” to cancel).*

10. **Disable Clam**  

    ```bash
    clam disable
    ```  

    *Temporarily disable the Clam.sh completion function.*

11. **Enable Clam**  

    ```bash
    clam enable
    ```  

    *Re-enable the clam functionality and verify that it is active.*

12. **Clear Cache and Logs**  

    ```bash
    clam clear
    ```  

    *This will purge cached completions and log data—confirm the action when prompted.*

13. **Remove the Installation**  

    ```bash
    clam remove
    ```  

    *Clean up by removing the configuration, cache, log files, and the bashrc modifications.*

Running these commands sequentially (or in various orders to simulate different user scenarios) will help you put the script through its paces and ensure that all functionality works as expected.