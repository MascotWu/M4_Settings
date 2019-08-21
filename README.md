设计文档
信号选择
选择速度信号的来源
CAN信号
模拟
GPS
实现方式：
写/sdcard/run/can_input.json


CAN信号车型表：

把can_input.json里面对应的speed left_turn right_turn替换成对应车型的。

模拟 + GPS

{
  'ANALOG|speed': {
    "can_id": "0x783",
    "byte_order": 0,
    "start_bit": 8,
    "size": 16,
    "min": 0,
    "max": 512,
    "factor": 1,
    "offset": 0
  },
  'GPS|speed': {
    "can_id": "0x20000000",
    "byte_order": 0,
    "start_bit": 8,
    "size": 16,
    "min": 0,
    "max": 512,
    "factor": 1,
    "offset": 0
  },
  'ANALOG|left_turn': {
    "can_id": "0x20000000",
    "byte_order": 0,
    "start_bit": 0,
    "size": 1,
    "min": 0,
    "max": 1,
    "factor": 1,
    "offset": 0
  },
  'ANALOG|right_turn': {
    "can_id": "0x20000000",
    "byte_order": 0,
    "start_bit": 1,
    "size": 1,
    "min": 0,
    "max": 1,
    "factor": 1,
    "offset": 0
  }
}
如果选择模拟信号，那么就把   'ANALOG|speed'     'ANALOG|left_turn'   'ANALOG|right_turn' 对应的内容替换到/sdcard/run/can_input.json的 speed left-turn right_turn，并且把
    "m4_analog": {
        "aspeed": {
            "ratio": 0,
            "enable": false
        },
        "aturnlamp": {
            "enable": false,
            "polarity": 1
        }



选择信号的波特率
500k
250k
实现方式
/sdcard/run/can_input.json
修改.main.baudrate
类型：字符串
可能的值：500k 250k
摄像头
3.1 设置参数

参数						默认值
​
车宽							2.2
摄像头高度					1.5
摄像头离玻璃右边缘 ① 			0.8
摄像头离玻璃左边缘 ② 			0.8
摄像头离车头 ③ 				0.1
车前轮轴到车头 ④ 				1.5

实现方式
修改以下两个文件，填写的时候需要做一个简单的计算：
车辆配置文件/sdcard/run/macros_config.txt
camera_height
left_dist_to_camera
right_dist_to_camera
front_dist_to_camera

车道配置文件/sdcard/run/detect.flag
camera_height
    		left_vehicle_edge_dist
    		right_vehicle_edge_dist
front_wheel_camera_dist
front_vehicle_edge_dist

3.2标定
标定方式：灭点标定
拖动绿色的线，使它和车道线重合
计算角度
实现方式：

4.报警和通知（功能开关）

FCW报警		/sdcard/run/detect.flag	enable_fcw
HMW报警	/sdcard/run/detect.flag	enable_hmw
LDW报警		/sdcard/run/detect.flag	enable_ldw
行人预警		/sdcard/run/detect.flag	enable_pcw
超速预警		/sdcard/run/detect.flag	enable_tsr

正常情况下配置完之后是需要执行这两条命令才能生效的，但是鉴于本项目是安装工具，设置完一定会重启，所以就不需要执行这两条命令。
stop adas;
start adas;

轻度闭眼			/sdcard/run/dms_setup.flag		alert_item_eyeclose1
重度闭眼			/sdcard/run/dms_setup.flag		alert_item_eyeclose2
低头				/sdcard/run/dms_setup.flag		alert_item_bow
打电话			/sdcard/run/dms_setup.flag		alert_item_phone
左顾右盼			/sdcard/run/dms_setup.flag		alert_item_lookaround
打哈欠			/sdcard/run/dms_setup.flag		alert_item_yawn
吸烟				/sdcard/run/dms_setup.flag		alert_item_smoking
离岗				/sdcard/run/dms_setup.flag		alert_item_demobilized
驾驶员变更		/sdcard/run/dms_setup.flag		alert_item_driverchange
遮挡				/sdcard/run/dms_setup.flag		alert_item_occlusion
抬头				/sdcard/run/dms_setup.flag		alert_item_lookup
墨镜遮挡			/sdcard/run/dms_setup.flag		alert_item_eyeocclusion
双手脱离方向盘	/sdcard/run/dms_setup.flag		alert_item_handsoff
长时间驾驶		/sdcard/run/dms_setup.flag		alert_item_longtimedrive

正常情况下配置完之后是需要执行这两条命令才能生效的，但是鉴于本项目是安装工具，设置完一定会重启，所以就不需要执行这两条命令。
stop dms;
start dms;

5.设置协议
实现方式：向/data/mprot/mprot.json 写入配置指定协议
{      'protocol': proto    };

天迈协议
JT808协议
服务器地址
服务器端口
设备ID（协议设备ID）
关联视频
忽略速度限制
车牌号
车牌颜色
终端ID
附件分辨率

实现方式：
向/data/mprot/config/config.json写入配置，格式如下：

{
	"server": {
		"ipaddr": "服务器ip地址",
		"port": "服务器端口号",
		"heartbeat_period": 60
	},
	"reg_param": {
		"province_id": 0,
		"city_id": 0,
		"vendor": "MNEYE",
		"product": "MINIEYE_ADAS/DSM",
		"dev_id": "终端id",
		"plate_color": "车牌颜色 plate_color=1 blue 2 yellow 3 black 4 white 9 others ",
		"car_num": "车牌号",
		"reg_id": "协议设备id",
		"associated_video": true
	},
	"resolution": {
		"adas_video": "config_fields.adas_video_resolution",
		"adas_image": "config_fields.adas_image_resolution",
		"dms_video": "config_fields.dms_video_resolution",
		"dms_image": "config_fields.dms_image_resolution"
	},
	"nocan_tm_thres": 4,
	"ignore_spdth": false
}

设备ID：16位的16进制数字
终端ID：默认值是设备ID的后7位，字母转大写。格式必须是7位，由大写字母或数字组成。
协议设备ID：我们的设备id前面的8位，然后转成10进制，再补全到12位。格式必须是12位纯数字。
附件分辨率：一共有几个选项CIF HD1 D1 VGA 720P 1080P

苏标协议
关联视频
使用部标机信号
附件分辨率

实现方式：
向/data/mprot/config/config.json写入配置，格式如下：
{
	"protocol": {
		"type": "subiao",
		"associated_video": true,
		"use_rtdata": false
	},
	"resolution": {
		"adas_video": config_fields.adas_video_resolution,
		"adas_image": config_fields.adas_image_resolution,
		"dms_video": config_fields.dms_video_resolution,
		"dms_image": config_fields.dms_image_resolution
	}
}

6.设置音量
0-3

设置音量的接口：
get_system_volume(): 获取系统音量
   发送的JSON字符串是: {"type": "get_system_volume", "data": null}
   成功时返回: {"type": "get_system_volume_ok", "result": volume}
   在M3,M4设备上，volume是一个浮点数，通常在[0.0, 0.8]之间。
   虽然是浮点数，其实只有4级，0.0:静音，0.2, 0.5, 0.8 音量依次增大。

set_system_volume(volume): 设置系统音量。
   发送的JSON字符串是: {"type": "set_system_volume", "data": volume}
   参数：volume可选值: 0.0:静音，0.2, 0.5, 0.8 音量依次增大。
   成功时返回: {"type": "set_system_volume_ok", "result": volume}
   返回的volume一般就是你设置的volume。但是系统会自动修正非法音量值，所以有时候返回的volume不一定等于设置的volume。

7.设置假速度
	无 20km/h 40km/h 60km/h
实现方式
/sdcard/run/can_input.json
修改.main.fake_speed
类型：整数
取值：不限
当设置成无的时候，删除这一项配置。

8.拍照
实现方式：
请求体
{
	"type": "get_camera_image",
	"data": {
		"camera": "adas"
	}
}
camera: adas, driver
返回值
{
	"type": "get_camera_image_ok",
	"data": {
		"format": "jpeg",
		"size": 123123,
			"image": "base64 string"
	}
}


9.附件
can_input.json
{

    "main": {
        "use_obd": false,
        "baudrate": "250K",
        "scenario": 0,
        "enable_e1": false
    },
    "speed": {
        "max": 65535,
        "min": 0,
        "size": 16,
        "can_id": "0x18FEF100",
        "factor": 0.0039,
        "offset": 0,
        "source": {
            "id": 17614,
            "name": "BYD, C8, 2018",
            "type": "CAR_MODEL"
        },
        "start_bit": 8,
        "byte_order": 0
    },
    "left_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "source": {
            "id": 17665,
            "name": "BYD, C8/K8, 2018",
            "type": "CAR_MODEL"
        },
        "start_bit": 12,
        "byte_order": 0
    },
    "m4_analog": {
        "aspeed": {
            "ratio": 0,
            "enable": false
        },
        "aturnlamp": {
            "enable": false,
            "polarity": 1
        }
    },
    "right_turn": {
        "max": 1,
        "min": 0,
        "size": 1,
        "can_id": "0x18FED925",
        "factor": 1,
        "offset": 0,
        "source": {
            "id": 17665,
            "name": "BYD, C8/K8, 2018",
            "type": "CAR_MODEL"
        },
        "start_bit": 10,
        "byte_order": 0
    }
}
can车型表
{
    "黄海 | 纯电动 | 2019": {
        "speed": {
            "max": 1142.721115519835,
            "min": 0,
            "size": 15,
            "can_id": "0x18ef01ef",
            "factor": 0.03487308091796371,
            "offset": 0,
            "start_bit": 35,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18fef217",
            "factor": 1,
            "offset": 0,
            "start_bit": 18,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18fef217",
            "factor": 1,
            "offset": 0,
            "start_bit": 19,
            "byte_order": 0
        }
    },
    "黄海 | 6109 | 2019": {
        "speed": {
            "max": 1142.721115519835,
            "min": 0,
            "size": 15,
            "can_id": "0x18ef01ef",
            "factor": 0.03487308091796371,
            "offset": 0,
            "start_bit": 35,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18fef217",
            "factor": 1,
            "offset": 0,
            "start_bit": 18,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18fef217",
            "factor": 1,
            "offset": 0,
            "start_bit": 19,
            "byte_order": 0
        }
    },
    "比亚迪 | K7 | 2016": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF100",
            "factor": 0.0039,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | K7g | 2019": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF100",
            "factor": 0.0039,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | K8 | 2016": {
        "speed": {
            "max": 512,
            "min": -20,
            "size": 16,
            "can_id": "0x18FEF100",
            "factor": 0.003906,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0,
            "is_unsigned": false
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | C8 | 2016": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18F31100",
            "factor": 0.06875,
            "offset": 0,
            "start_bit": 24,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | K7 | 2019": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF100",
            "factor": 0.0039,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | k8 | 2015": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEBF0B",
            "factor": 0.00390625,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 1
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | K8 | 2019": {
        "speed": {
            "max": 65535,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEBF0B",
            "factor": 0.00390625,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 1
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18FED925",
            "factor": 1,
            "offset": 0,
            "start_bit": 10,
            "byte_order": 0
        }
    },
    "比亚迪 | K9 | 2013": {
        "speed": {
            "max": 5047.44472284689,
            "min": 0,
            "size": 16,
            "can_id": "0x456",
            "factor": 0.07701789433054947,
            "offset": 0,
            "start_bit": 24,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x12E",
            "factor": 1,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x12E",
            "factor": 1,
            "offset": 0,
            "start_bit": 17,
            "byte_order": 0
        }
    },
    "南京金龙 | NJL0968NV7 | 2019": {
        "speed": {
            "max": 256,
            "min": 0,
            "size": 16,
            "can_id": "0x18F101D0 ",
            "factor": 0.003906,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117 ",
            "factor": 1,
            "offset": 0,
            "start_bit": 15,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117",
            "factor": 1,
            "offset": 0,
            "start_bit": 14,
            "byte_order": 0
        }
    },
    "南京金龙 | NJL0968NK7 | 2019": {
        "speed": {
            "max": 256,
            "min": 0,
            "size": 16,
            "can_id": "0x18F101D0 ",
            "factor": 0.003906,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117 ",
            "factor": 1,
            "offset": 0,
            "start_bit": 15,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117",
            "factor": 1,
            "offset": 0,
            "start_bit": 14,
            "byte_order": 0
        }
    },
    "宇通 | ZK6125BEVG75 | 2018": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | 6201 | 2019": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF121",
            "factor": 0.00390625,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 1
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | e10 | 2018": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | 6125 | 2019": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF121",
            "factor": 0.00390625,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 1
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | E8 | 2017": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FEF121",
            "factor": 0.9972,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | 6805 | 2016": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | e8 | 2018": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FEF121",
            "factor": 0.9972,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | ZK6805 | 2015": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | 6805 | 2015": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "宇通 | 6850 | 2016": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 8,
            "can_id": "0x18FF0824",
            "factor": 1.0008,
            "offset": 0,
            "start_bit": 16,
            "byte_order": 0
        },
        "left_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 32,
            "byte_order": 0
        },
        "right_turn": {
            "max": 512,
            "min": 0,
            "size": 1,
            "can_id": "0x18A70017",
            "factor": 1,
            "offset": 0,
            "start_bit": 34,
            "byte_order": 0
        }
    },
    "开沃 | NJL6859EV7 | 2019": {
        "speed": {
            "max": 256,
            "min": 0,
            "size": 16,
            "can_id": "0x18F101D0 ",
            "factor": 0.003906,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117 ",
            "factor": 1,
            "offset": 0,
            "start_bit": 15,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F40117",
            "factor": 1,
            "offset": 0,
            "start_bit": 14,
            "byte_order": 0
        }
    },
    "速达 | 速达 | 2019": {
        "speed": {
            "max": 220,
            "min": 0,
            "size": 16,
            "can_id": "0x441",
            "factor": 0.01,
            "offset": 0,
            "start_bit": 0,
            "byte_order": 1
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x422",
            "factor": 1,
            "offset": 0,
            "start_bit": 2,
            "byte_order": 1
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x422",
            "factor": 1,
            "offset": 0,
            "start_bit": 3,
            "byte_order": 1
        }
    },
    "中通 | LCK6120EVG3A1 | 2019": {
        "speed": {
            "max": 255,
            "min": 0,
            "size": 16,
            "can_id": "0x18FEF117",
            "factor": 0.00390625,
            "offset": 0,
            "start_bit": 8,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F00117",
            "factor": 1,
            "offset": 0,
            "start_bit": 27,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F00117",
            "factor": 1,
            "offset": 0,
            "start_bit": 26,
            "byte_order": 0
        }
    },
    "中兴 | GTZ6859BEVB2 | 2019": {
        "speed": {
            "max": 512,
            "min": 0,
            "size": 16,
            "can_id": "0x18F15217 ",
            "factor": 0.1,
            "offset": 0,
            "start_bit": 24,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F15317 ",
            "factor": 1,
            "offset": 0,
            "start_bit": 6,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0x18F15317 ",
            "factor": 1,
            "offset": 0,
            "start_bit": 4,
            "byte_order": 0
        }
    },
    "中车 | v08 | 2019": {
        "speed": {
            "max": 1296.586191214897,
            "min": 0,
            "size": 16,
            "can_id": "0xc03a1a7",
            "factor": 0.01978433519309841,
            "offset": 0,
            "start_bit": 48,
            "byte_order": 0
        },
        "left_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0xc19a7a1",
            "factor": 1,
            "offset": 0,
            "start_bit": 15,
            "byte_order": 0
        },
        "right_turn": {
            "max": 1,
            "min": 0,
            "size": 1,
            "can_id": "0xc19a7a1",
            "factor": 1,
            "offset": 0,
            "start_bit": 12,
            "byte_order": 0
        }
    }
}
