//
//  ViewController.m
//  FFmpegStudy
//
//  Created by chenq@kensence.com on 16/9/7.
//  Copyright © 2016年 chenq@kensence.com. All rights reserved.
//

#import "ViewController.h"
#import "KxMovieViewController.h"
#import <libavformat/avformat.h>
#import <libavutil/mathematics.h>
#import <libavutil/time.h>
#import "VideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 10, 100, 50);
    [button setTitle:@"解码" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor brownColor];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(100, 100, 100, 50);
    [button1 setTitle:@"推流" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button1];
}

- (void)button:(UIButton *)button
{
    VideoViewController *VC = [[VideoViewController alloc]init];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)button1:(UIButton *)button
{
    char input_str_full[500] = {0};
    char output_str_full[500] = {0};
    
    NSString *input_str = [NSString stringWithFormat:@"resource.bundle/%@",@"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4"];
    NSString *input_nsstr = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:input_str];
    sprintf(input_str_full,"%s", [input_nsstr UTF8String]);
    sprintf(output_str_full,"%s", [@"https://github.com/githupchenqiang/Bantang.git" UTF8String]);
    
    printf("Input Path:%s\n",input_str_full);
    printf("Output Path:%s\n",output_str_full);
   
    AVOutputFormat *format = NULL;
    AVFormatContext *ifmt_ctx = NULL,*ofmt_ctx = NULL;
    AVPacket pkt;
    char in_filename[500] = {0};
    char out_filename[500] = {0};
    int ret,i;
    
    int videoindex = -1;
    int frame_index = 0;
    int64_t start_time = 0;
    
    strcpy(in_filename, input_str_full);
    strcpy(out_filename, output_str_full);
    av_register_all();
    avformat_network_init();
    
    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) <0) {
        goto end;
    
    }
    
    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0) {
        printf( "Failed to retrieve input stream information");
        goto end;
    }
   
    for (i= 0; i < ifmt_ctx->nb_streams; i++) {
        if (ifmt_ctx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO) {
            videoindex = i;
            break;
        }
        av_dump_format(ifmt_ctx, 0, in_filename, 0);
    }
    avformat_alloc_output_context2(&ofmt_ctx, NULL, "flv", out_filename);//RTMP
    //avformat_alloc_output_context2(&ofmt_ctx, NULL, "mpegts", out_filename);//UDP
    
    if (!ofmt_ctx) {
        printf( "Could not create output context\n");
        ret = AVERROR_UNKNOWN;
        goto end;
        
    }
    format = ofmt_ctx->oformat;
    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec);
        if (!out_stream) {
            printf( "Failed allocating output stream\n");
            ret = AVERROR_UNKNOWN;
            goto end;
        }
        
        ret = avcodec_copy_context(out_stream->codec, in_stream->codec);
        if (ret < 0) {
             printf( "Failed to copy context from input to output stream codec context\n");
            goto end;
        }
        out_stream->codec->codec_tag = 0;
        if (ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER) {
            out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
        }
        
        av_dump_format(ofmt_ctx, 0, out_filename, 1);
        if (!(format->flags & AVFMT_NOFILE)) {
            ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
            if (ret < 0) {
                  printf( "Could not open output URL '%s'", out_filename);
                goto end;
            }
        }
        ret = avformat_write_header(ofmt_ctx, NULL);
        if (ret < 0) {
             printf( "Error occurred when opening output URL\n");
            goto end;
        }
        
        start_time = av_gettime();
        while (1) {
            AVStream *in_stream,*out_stream;
            ret = av_read_frame(ifmt_ctx, &pkt);
            if (ret < 0)
                break;
            if (pkt.pts == AV_NOPTS_VALUE) {
                AVRational time_base1 = ifmt_ctx->streams[videoindex]->time_base;
                int64_t calc_duration = (double)AV_TIME_BASE/av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
                pkt.pts = (double)(frame_index *calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
                pkt.dts = pkt.pts;
                pkt.duration = (double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
            }
            
            if (pkt.stream_index == videoindex) {
                AVRational time_base = ifmt_ctx->streams[videoindex]->time_base;
                AVRational time_base_q = {1,AV_TIME_BASE};
                int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
                int64_t now_time = av_gettime() - start_time;
                if (pts_time > now_time) 
                    av_usleep(pts_time - now_time);
               
                in_stream = ifmt_ctx->streams[pkt.stream_index];
                out_stream = ofmt_ctx->streams[pkt.stream_index];
                
                pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base,(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
                pkt.pts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, (AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX));
                pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
                pkt.pos = -1;
                if (pkt.stream_index == videoindex) {
                    printf("Send %8d video frames to output URL\n",frame_index);
                    frame_index++;
                }
                ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
                if (ret < 0) {
                    printf( "Error muxing packet\n");
                    break;
                }
                av_free_packet(&pkt);
            }
            
        }
        
        
    }

    av_write_trailer(ofmt_ctx);
end:
    avformat_close_input(&ifmt_ctx);
    if (ofmt_ctx && !(format->flags & AVFMT_NOFILE))
        avio_close(ofmt_ctx->pb);
        avformat_free_context(ofmt_ctx);
        if (ret < 0 && ret != AVERROR_EOF) {
            return;
        }
        return;
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
