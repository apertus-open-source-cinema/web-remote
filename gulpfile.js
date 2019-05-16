const gulp = require('gulp');
const riot = require('gulp-riot');
const concat = require('gulp-concat');
const crass = require('gulp-crass');
const minify = require('gulp-minify');
const simplePreprocess = require('gulp-simple-preprocess');
const browserSync = require('browser-sync');
const pump = require('pump');
const swPrecache = require('sw-precache');
/* Font Creation */
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');
var fontName = 'axiom-icons';
var runTimestamp = Math.round(Date.now() / 1000);
/* Development Server Websocket */
var run = require('gulp-run');

gulp.task('prod_mode', (cb) => {
  return gulp.src('./src/index.html')
    .pipe(simplePreprocess({
      env: 'prod'
    }))
    .pipe(gulp.dest('dest'));
});

gulp.task('dev_mode', (cb) => {
  return gulp.src('./src/index.html')
    .pipe(simplePreprocess({
      env: 'dev'
    }))
    .pipe(gulp.dest('dest'));
});

gulp.task('service-worker', (cb) => {
  var rootDir = 'dest';
  swPrecache.write(`${rootDir}/serviceworker.js`, {
    staticFileGlobs: [rootDir + '/**/*.{js,html,css,json,png,jpg,gif,svg,eot,ttf,woff,woff2}'],
    stripPrefix: rootDir
  }, cb);
});

gulp.task('riot_build', (cb) => {
  pump([
    gulp.src('src/components/*.tag'),
    riot({
      compact: false
    }),
    concat('components_all.js'),
    // minify(),
    gulp.dest('dest/components')
  ],
  cb
  );
});

gulp.task('process_js', (cb) => {
  pump([
    gulp.src(['src/js/riot.min.js', 'src/js/app.js']),
    concat('app.js'),
    gulp.dest('dest/js')
  ],
  cb
  );
});

gulp.task('process_css', (cb) => {
  pump([
    gulp.src(['src/css/**/*']),
    concat('webremote.css'),
    crass({ pretty: true }),
    gulp.dest('dest/css'),
    browserSync.stream()
  ], cb);
});

gulp.task('process_iconfont', (cb) => {
  pump([ gulp.src(['./src/icon/svg/*.svg']),
    iconfontCss({
      fontName: fontName, // The name that the generated font will have
      path: 'src/icon/_icons.css', // The path to the template that will be used to create the SASS/LESS/CSS file
      targetPath: '../../dest/css/' + fontName + '.css', // The path where the file will be generated
      fontPath: '../icons/' // The path to the icon font file
    }),
    iconfont({
      fontName: fontName, // required
      prependUnicode: false, // recommended option
      formats: ['eot', 'woff', 'ttf', 'svg'], // default, 'woff2' and 'svg' are available
      timestamp: runTimestamp, // recommended to get consistent builds when watching files
      // fontHeight: '1001',
      normalize: true
    })
      .on('glyphs', function (glyphs, options) {
      // CSS templating, e.g.
        console.log(glyphs, options);
      }),
    gulp.dest('dest/icons/')], cb);
});

const staticPaths = ['./src/*.js', './src/*.json', './src/icon/**/*', './src/json/**/*', './src/img/**/*'];

const staticList =
{
  'base': ['./src/*.{json,js}', './dest/'],
  'font': ['./src/font/**/*', './dest/font/'],
  'image': ['./src/img/**/*', './dest/img/'],
  'json_data': ['./src/json/**/*', './dest/json/']
};

gulp.task('copy_static', (cb) => {
  for (var count in staticList) {
    gulp.src([staticList[count][0]]).pipe(gulp.dest(staticList[count][1]));
  }

  cb();
});

gulp.task('browser-sync', function () {
  return browserSync.init({
    injectChanges: true,
    server: {
      baseDir: ['./dest']
    }
  });
});

gulp.task('dev_server', function () {
  return run('node devServer/app.js').exec();
});

gulp.task('watch', gulp.series('browser-sync', () => {
  gulp.watch(staticPaths, gulp.series('copy_static')).on('change', browserSync.reload);
  gulp.watch('./src/js/**/*', gulp.series('process_js')).on('change', browserSync.reload);
  gulp.watch('./src/components/**/*', gulp.series('riot_build')).on('change', browserSync.reload);
  gulp.watch('./src/index.html', gulp.series('dev_mode')).on('change', browserSync.reload);
  gulp.watch('./src/css/**/*', gulp.series('process_css'));
}));

gulp.task('run_dev', gulp.series('service-worker', 'dev_mode', 'watch'));

gulp.task('build', gulp.series('riot_build', 'process_css', 'process_js', 'process_iconfont', 'copy_static', 'prod_mode'));

gulp.task('default', gulp.series('riot_build', 'process_css', 'process_js', 'process_iconfont', 'copy_static'));

gulp.task('run_devServer', gulp.series('dev_server', 'run_dev'));

gulp.task('run_server', gulp.series('dev_server'));
