package ustc.nodb.properties;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class GlobalConfig {

    // Graph Sketch Config
    public static final byte hashNum;
    public static final short compressionRate;
    public static final int k;
    public static final int l;

    // Graph env config
    public static String inputGraphPath;
    public static String outputGraphPath;
    public static String batchEdgePath;
    public static int vCount;
    public static int eCount;

    // Graph partition config
    public static int partitionNum;
    public static int clusterNumber;
    public static double tau;

    // Graph cluster packing config
    public static float alpha;
    public static int batchSize;
    public static int threads;

    static {
        InputStream inputStream = GlobalConfig.class.getResourceAsStream("/project.properties");
        Properties properties = new Properties();
        try {
            properties.load(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
        hashNum = Byte.parseByte(properties.getProperty("hashNum", "1"));
        compressionRate = Short.parseShort(properties.getProperty("compressionRate", "100"));
        inputGraphPath = properties.getProperty("inputGraphPath");
        outputGraphPath = properties.getProperty("outputGraphPath");
        vCount = Integer.parseInt(properties.getProperty("vCount"));
        eCount = Integer.parseInt(properties.getProperty("eCount"));
        partitionNum = Integer.parseInt(properties.getProperty("partitionNum"));
        alpha = Float.parseFloat(properties.getProperty("alpha"));
        k = Integer.parseInt(properties.getProperty("k"));
        l = Integer.parseInt(properties.getProperty("l"));
        batchSize = Integer.parseInt(properties.getProperty("batchSize"));
        threads = Integer.parseInt(properties.getProperty("threads"));
        // clusterNumber = Integer.parseInt(properties.getProperty("clusterNumber"));
        // batchEdgePath = properties.getProperty("batchEdgePath");
        // tau = Double.parseDouble(properties.getProperty("tau"));
    }

    public static byte getHashNum() {
        return hashNum;
    }

    public static int getCompressionRate() {
        return compressionRate;
    }

    public static String getInputGraphPath() {
        return inputGraphPath;
    }

    public static int getVCount() {
        return vCount;
    }

    public static int getECount() {
        return eCount;
    }

    public static int getPartitionNum() {
        return partitionNum;
    }

    public static int getMaxClusterVolume() {
        return eCount / partitionNum;
    }

    public static int getClusterNumber(){
        return clusterNumber;
    }

    public static float getAlpha() {
        return alpha;
    }

    public static int getK() {
        return k;
    }

    public static int getL() {
        return l;
    }

    public static int getBatchSize() {
        return batchSize;
    }

    public static int getThreads() {
        return threads;
    }

    public static String getOutputGraphPath() {
        return outputGraphPath;
    }
}
