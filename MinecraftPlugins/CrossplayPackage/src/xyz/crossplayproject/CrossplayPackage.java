package xyz.crossplayproject;

import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;
import spark.Service;

public class CrossplayPackage extends JavaPlugin {

    private BlockHandler blockHandler;
    private EntityHandler entityHandler;
    private POSTHandler postHandler;
    private Service sparkService;
    private int sparkPort;

    @Override
    public void onEnable() {

        if (!getDataFolder().exists()) {
            getDataFolder().mkdir();
        }
        saveDefaultConfig();

        FileConfiguration config = getConfig();
        sparkPort = config.getInt("webserver.port", 4567);

        blockHandler = new BlockHandler();
        entityHandler = new EntityHandler();
        postHandler = new POSTHandler();

        setupSpark();

        getLogger().info("CrossplayPackage has been enabled!");
    }

    private void setupSpark() {
        sparkService = Service.ignite();
        sparkService.port(sparkPort);

        blockHandler.setupRoutes(sparkService);
        entityHandler.setupRoutes(sparkService);
        postHandler.setupRoutes(sparkService);
    }

    @Override
    public void onDisable() {

        if (sparkService != null) {
            sparkService.stop();
            sparkService.awaitStop();
        }
        getLogger().info("CrossplayPackage has been disabled!");
    }
}
