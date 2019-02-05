const gulp = require('gulp');
const riot = require('gulp-riot');
const concat = require('gulp-concat');
// const uglify = require('gulp-uglify')
// const rename = require('gulp-rename')
const simplePreprocess = require('gulp-simple-preprocess');
const browserSync = require('browser-sync');
const pump = require('pump');
const swPrecache = require('sw-precache');
/* Font Creation */
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');
var fontName = 'axiom-icons';
var runTimestamp = Math.round(Date.now()/1000);
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

gulp.task('riot', (cb) => {
    pump([
        gulp.src('src/components/*.tag'),
        riot({
            compact: true
        }),
        concat('components_all.js'),
        // .pipe(gulp.dest('dest/components'))
        // .pipe(rename('components_all.min.js'))
        // .pipe(uglify()),
        gulp.dest('dest/components')
    ],
    cb        
    );
});

gulp.task('process_js', () => {
    // Consider to run uglify/minify over JS files later
    return gulp.src(['src/js/**/*']).pipe(gulp.dest('dest/js'));
});

gulp.task('process_css', () => {
    // Consider to run LESS/SASS/minifier processor over CSS files later
    return gulp.src(['src/css/**/*']).pipe(gulp.dest('dest/css')).pipe(browserSync.stream());
});

gulp.task('process_iconfont', function(){
    return gulp.src(['./src/icon/svg/*.svg'])
        .pipe(iconfontCss({
            fontName: fontName, // The name that the generated font will have
            path: 'src/icon/_icons.css', // The path to the template that will be used to create the SASS/LESS/CSS file
            targetPath: '../../dest/css/' + fontName + '.css', // The path where the file will be generated
            fontPath: '../icons/' // The path to the icon font file
        }))
        .pipe(iconfont({
            fontName: fontName, // required
            prependUnicode: false, // recommended option
            formats: ['eot', 'woff', 'ttf', 'svg'], // default, 'woff2' and 'svg' are available
            timestamp: runTimestamp, // recommended to get consistent builds when watching files
            // fontHeight: '1001',
            normalize: true
        }))
        .on('glyphs', function(glyphs, options) {
            // CSS templating, e.g.
            console.log(glyphs, options);
        })
        .pipe(gulp.dest('dest/icons/'));
});

const static_paths = ['./src/*.js','./src/*.json', './src/icon/**/*', './src/json/**/*', './src/img/**/*'];

const static_list =  
{
    'base':['./src/*.{json,js}', './dest/'],
    'font':['./src/font/**/*', './dest/font/'],
    'image':['./src/img/**/*', './dest/img/'],
    'json_data':['./src/json/**/*', './dest/json/']
};

gulp.task('copy_static', () => {
    for(count in static_list) {
        gulp.src([static_list[count][0]]).pipe(gulp.dest(static_list[count][1]));
    }
});

gulp.task('browser-sync', function () {
    return browserSync.init({
        injectChanges: true,
        server: {
            baseDir: ['./dest']
        }
    });
});

gulp.task('dev_server', function (){
    return run('node devServer/app.js').exec();
});

gulp.task('watch', ['browser-sync'], () => {
    gulp.watch(static_paths, ['copy_static']).on('change', browserSync.reload);
    gulp.watch('./src/js/**/*', ['process_js']).on('change', browserSync.reload);
    gulp.watch('./src/components/**/*', ['riot']).on('change', browserSync.reload);
    gulp.watch('./src/css/**/*', ['process_css']);
});

gulp.task('run_dev', ['default', 'dev_mode', 'watch']);

gulp.task('build', ['default', 'prod_mode']);

gulp.task('default', ['service-worker','riot', 'process_css', 'process_js','process_iconfont', 'copy_static']);

gulp.task('run_devServer', ['dev_server', 'run_dev']);

gulp.task('run_server', ['dev_server']);