const gulp = require('gulp');
const riot = require('gulp-riot');
const concat = require('gulp-concat')
// const uglify = require('gulp-uglify')
// const rename = require('gulp-rename')
const browserSync = require('browser-sync');
const pump = require('pump');
const swPrecache = require('sw-precache');

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
        // .pipe(uglify())
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

const static_paths = ['./src/*.html', './src/*.js','./src/*.json', './src/icon/**/*', './src/json/**/*', './src/img/**/*'];

const static_list =  
{
    'base':['./src/*.{html,json,js}', './dest/'],
    'icon':['./src/icon/**/*', './dest/icon/'], 
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

gulp.task('watch', ['browser-sync'], () => {
    gulp.watch(static_paths, ['copy_static']).on('change', browserSync.reload);
    gulp.watch('./src/js/**/*', ['process_js']).on('change', browserSync.reload);
    gulp.watch('./src/components/**/*', ['riot']).on('change', browserSync.reload);
    gulp.watch('./src/css/**/*', ['process_css']);
});

gulp.task('run_dev', ['default', 'watch']);

gulp.task('default', ['service-worker','riot', 'process_css', 'process_js', 'copy_static']);
