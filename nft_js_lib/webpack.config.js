import path from 'path';
import { merge } from 'webpack-merge';

// Shared Base Configuration
const baseConfig = {
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                },
            },
        ],
    },
};

// Development Configuration (for testing with webpack-dev-server)
const devConfig = {
    entry: './src/index-dev.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve('./dist'),
    },
    mode: 'development',
    devServer: {
        static: {
            directory: path.join('./dist'),
        },
        compress: true,
        port: 9000,
    },
};

// Production Configuration (for export as a library)
const prodConfig = {
    entry: './src/index-prod.js',
    output: {
        filename: 'LibJsNft.js',
        path: path.resolve('./dist'),
        library: 'LibJsNft', // Name of the global variable for the library
        libraryTarget: 'umd', // UMD format for compatibility
        globalObject: 'this', // Ensures compatibility in different environments
    },
    mode: 'production', // Minify and optimize output for production
};

// Exporting based on environment
export default (env) => {
    if (env && env.production) {
        return merge(baseConfig, prodConfig);
    }
    return merge(baseConfig, devConfig);
};