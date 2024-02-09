const path = require('path')

module.exports = {
	entry: path.join(__dirname, 'src/js', 'index.js'), //frontend
	output: {
		path: path.join(__distname, 'dist'),
		filename: 'build.js' //final file 'dist/build.js'
	},
	module: {
		rules: [{
			test: /\.css$/, // To load the css in react
			use: ['style-loader', 'css-loader'],
			include: /src/
		}, {
			test: /\.jsx?$/, // load js and jsx files
			loader: 'babel-loader',
			exclude: /node_modules/,
			query: {
				presets: ['es2015', 'react', 'stage-2']
			}
		}]
	}
}

