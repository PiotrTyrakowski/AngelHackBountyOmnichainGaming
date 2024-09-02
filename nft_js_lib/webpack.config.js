import path from 'path';

export default {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve('./dist'),
    },
    mode: 'development',
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
    devServer: {
        static: {
            directory: path.join('./dist'),
        },
        compress: true,
        port: 9000,
    },
};
