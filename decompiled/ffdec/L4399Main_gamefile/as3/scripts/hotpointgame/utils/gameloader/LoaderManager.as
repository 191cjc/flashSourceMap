package hotpointgame.utils.gameloader
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import hotpointgame.utils.*;
   
   public class LoaderManager
   {
      
      public static var loads:Object = new Object();
      
      public static var allClassName:Object = new Object();
      
      public static var nameToFilename:Object = new Object();
      
      private var _loadingname:Array = [];
      
      private var currentUrlNum:int;
      
      private var totalUrlNum:int;
      
      private var loadMcM:LoaderProMc;
      
      private var _completeF:Function;
      
      private var isKeYiUse:Boolean = true;
      
      private var tempSwfLoaderm:SwfLoader;
      
      public function LoaderManager()
      {
         super();
      }
      
      public static function isLoadedBySwfname(param1:String) : Boolean
      {
         return loads.hasOwnProperty(param1);
      }
      
      public static function isLoadedByMcname(param1:String) : Boolean
      {
         return loads.hasOwnProperty(allClassName[param1]);
      }
      
      public static function initFilename() : void
      {
         nameToFilename["JijiaA_guangmingzhixing"] = "JijiaA_guangmingzhixingv27.swf";
         nameToFilename["skin_man"] = "skin_manv213.swf";
         nameToFilename["e_chushitao"] = "e_chushitaov12.swf";
         nameToFilename["e_yaodaifena"] = "e_yaodaifenav12.swf";
         nameToFilename["e_yaodaijina"] = "e_yaodaijinav12.swf";
         nameToFilename["e_yaodailana"] = "e_yaodailanav12.swf";
         nameToFilename["e_kaijiafena"] = "e_kaijiafenav12.swf";
         nameToFilename["e_kaijiajina"] = "e_kaijiajinav12.swf";
         nameToFilename["e_kaijialana"] = "e_kaijialanav12.swf";
         nameToFilename["e_huwanfena"] = "e_huwanfenav12.swf";
         nameToFilename["e_huwanjina"] = "e_huwanjinav12.swf";
         nameToFilename["e_huwanlana"] = "e_huwanlanav12.swf";
         nameToFilename["e_huwanfenb"] = "e_huwanfenbv141.swf";
         nameToFilename["e_kaijiafenb"] = "e_kaijiafenbv14.swf";
         nameToFilename["e_yaodaifenb"] = "e_yaodaifenbv141.swf";
         nameToFilename["e_huwanjinb"] = "e_huwanjinbv142.swf";
         nameToFilename["e_kaijiajinb"] = "e_kaijiajinbv142.swf";
         nameToFilename["e_yaodaijinb"] = "e_yaodaijinbv142.swf";
         nameToFilename["e_yaodaijinc"] = "e_yaodaijincv30.swf";
         nameToFilename["e_yaodaifenc"] = "e_yaodaifencv30.swf";
         nameToFilename["e_wyaodaijinc"] = "e_wyaodaijincv30.swf";
         nameToFilename["e_wyaodaifenc"] = "e_wyaodaifencv30.swf";
         nameToFilename["e_wkaijiajinc"] = "e_wkaijiajincv30.swf";
         nameToFilename["e_wkaijiafenc"] = "e_wkaijiafencv30.swf";
         nameToFilename["e_whuwanjinc"] = "e_whuwanjincv30.swf";
         nameToFilename["e_whuwanfenc"] = "e_whuwanfencv30.swf";
         nameToFilename["e_kaijiajinc"] = "e_kaijiajincv30.swf";
         nameToFilename["e_kaijiafenc"] = "e_kaijiafencv30.swf";
         nameToFilename["e_huwanjinc"] = "e_huwanjincv30.swf";
         nameToFilename["e_huwanfenc"] = "e_huwanfencv30.swf";
         nameToFilename["e_wchushitao"] = "e_wchushitaov28.swf";
         nameToFilename["skin_wman"] = "skin_wmanv295.swf";
         nameToFilename["e_whuwanfena"] = "e_whuwanfenav295.swf";
         nameToFilename["e_whuwanfenb"] = "e_whuwanfenbv28.swf";
         nameToFilename["e_whuwanjina"] = "e_whuwanjinav28.swf";
         nameToFilename["e_whuwanjinb"] = "e_whuwanjinbv28.swf";
         nameToFilename["e_whuwanlana"] = "e_whuwanlanav28.swf";
         nameToFilename["e_wkaijiafena"] = "e_wkaijiafenav295.swf";
         nameToFilename["e_wkaijiafenb"] = "e_wkaijiafenbv28.swf";
         nameToFilename["e_wkaijiajina"] = "e_wkaijiajinav28.swf";
         nameToFilename["e_wkaijiajinb"] = "e_wkaijiajinbv28.swf";
         nameToFilename["e_wkaijialana"] = "e_wkaijialanav28.swf";
         nameToFilename["e_wyaodaifena"] = "e_wyaodaifenav295.swf";
         nameToFilename["e_wyaodaifenb"] = "e_wyaodaifenbv28.swf";
         nameToFilename["e_wyaodaijina"] = "e_wyaodaijinav28.swf";
         nameToFilename["e_wyaodaijinb"] = "e_wyaodaijinbv28.swf";
         nameToFilename["e_wyaodailana"] = "e_wyaodailanav28.swf";
         nameToFilename["sz_wanheizypifeng"] = "sz_wanheizypifengv29.swf";
         nameToFilename["sz_wanheizyxg"] = "sz_wanheizyxgv29.swf";
         nameToFilename["sz_wcqzhchibang"] = "sz_wcqzhchibangv29.swf";
         nameToFilename["sz_wcqzhkaijia"] = "sz_wcqzhkaijiav29.swf";
         nameToFilename["sz_wcqzhxg"] = "sz_wcqzhxgv28.swf";
         nameToFilename["sz_wmaerkaijia"] = "sz_wmaerkaijiav29.swf";
         nameToFilename["sz_wmaerpiaodai"] = "sz_wmaerpiaodaiv29.swf";
         nameToFilename["sz_wmaerzyxg"] = "sz_wmaerzyxgv28.swf";
         nameToFilename["sz_wtlzgchibang"] = "sz_wtlzgchibangv29.swf";
         nameToFilename["sz_wtlzgkaijia"] = "sz_wtlzgkaijiav29.swf";
         nameToFilename["sz_wtlzgxg"] = "sz_wtlzgxgv28.swf";
         nameToFilename["sz_wtlzmchibang"] = "sz_wtlzmchibangv29.swf";
         nameToFilename["sz_wtlzmkaijia"] = "sz_wtlzmkaijiav29.swf";
         nameToFilename["sz_wtlzmxg"] = "sz_wtlzmxgv28.swf";
         nameToFilename["sz_wanheizykaijia"] = "sz_wanheizykaijiav29.swf";
         nameToFilename["sz_anheizykaijia"] = "sz_anheizykaijiav16.swf";
         nameToFilename["sz_anheizypifeng"] = "sz_anheizypifengv16.swf";
         nameToFilename["sz_maerkaijia"] = "sz_maerkaijiav26.swf";
         nameToFilename["sz_maerpiaodai"] = "sz_maerpiaodaiv142.swf";
         nameToFilename["sz_tlzgchibang"] = "sz_tlzgchibangv16.swf";
         nameToFilename["sz_tlzgkaijia"] = "sz_tlzgkaijiav221.swf";
         nameToFilename["sz_tlzmchibang"] = "sz_tlzmchibangv16.swf";
         nameToFilename["sz_tlzmkaijia"] = "sz_tlzmkaijiav16.swf";
         nameToFilename["sz_anheizyxg"] = "sz_anheizyxgv17.swf";
         nameToFilename["sz_maerzyxg"] = "sz_maerzyxgv17.swf";
         nameToFilename["sz_qixizgxg"] = "sz_qixizgxgv18.swf";
         nameToFilename["sz_tlzgxg"] = "sz_tlzgxgv21.swf";
         nameToFilename["sz_tlzmxg"] = "sz_tlzmxgv21.swf";
         nameToFilename["sz_cqzhxg"] = "sz_cqzhxgv232.swf";
         nameToFilename["sz_cqzhkaijia"] = "sz_cqzhkaijiav27.swf";
         nameToFilename["sz_cqzhchibang"] = "sz_cqzhchibangv27.swf";
         nameToFilename["sz_hlsdchibang"] = "sz_hlsdchibangv294.swf";
         nameToFilename["sz_hlsdkaijia"] = "sz_hlsdkaijiav294.swf";
         nameToFilename["sz_hlsdxg"] = "sz_hlsdxgv294.swf";
         nameToFilename["sz_mhsdchibang"] = "sz_mhsdchibangv294.swf";
         nameToFilename["sz_mhsdkaijia"] = "sz_mhsdkaijiav294.swf";
         nameToFilename["sz_mhsdxg"] = "sz_mhsdxgv294.swf";
         nameToFilename["sz_whlsdchibang"] = "sz_whlsdchibangv294.swf";
         nameToFilename["sz_whlsdkaijia"] = "sz_whlsdkaijiav294.swf";
         nameToFilename["sz_whlsdxg"] = "sz_whlsdxgv294.swf";
         nameToFilename["sz_wmhsdchibang"] = "sz_wmhsdchibangv294.swf";
         nameToFilename["sz_wmhsdkaijia"] = "sz_wmhsdkaijiav294.swf";
         nameToFilename["sz_wmhsdxg"] = "sz_wmhsdxgv294.swf";
         nameToFilename["sz_wlzscb"] = "sz_wlzscbv32.swf";
         nameToFilename["sz_wlzskaijia"] = "sz_wlzskaijiav32.swf";
         nameToFilename["sz_wlzsxg"] = "sz_wlzsxgv32.swf";
         nameToFilename["sz_wwlzscb"] = "sz_wwlzscbv32.swf";
         nameToFilename["sz_wwlzskaijia"] = "sz_wwlzskaijiav32.swf";
         nameToFilename["sz_wwlzsxg"] = "sz_wwlzsxgv32.swf";
         nameToFilename["xuanzeguanka"] = "j_xuanzeguankav44.swf";
         nameToFilename["kaipaijiemain"] = "j_pengfenv43.swf";
         nameToFilename["zhiyejineng"] = "j_zhiyejinengv29.swf";
         nameToFilename["j_jndhne"] = "j_jndhnev295.swf";
         nameToFilename["j_jndhny"] = "j_jndhnyv29.swf";
         nameToFilename["j_shangcheng"] = "j_shangchengv29.swf";
         nameToFilename["j_jieshaguaiwu"] = "j_jieshaguaiwuv44.swf";
         nameToFilename["j_qixihuodong"] = "j_qixihuodongv181.swf";
         nameToFilename["j_jingjiphjl"] = "j_jingjiphjlv43.swf";
         nameToFilename["m_baoxiang"] = "m_baowu.swf";
         nameToFilename["m_bianhu"] = "m_bianhu.swf";
         nameToFilename["m_gebulina"] = "m_gebulina.swf";
         nameToFilename["m_gebulinb"] = "m_gebulinb.swf";
         nameToFilename["m_gebulinc"] = "m_gebulinc.swf";
         nameToFilename["m_shirenyu"] = "m_shirenyu.swf";
         nameToFilename["m_shuimoa"] = "m_shuimoa.swf";
         nameToFilename["m_shuimob"] = "m_shuimob.swf";
         nameToFilename["m_shuimoboss"] = "m_shuimobossv27.swf";
         nameToFilename["m_xionga"] = "m_xionga.swf";
         nameToFilename["m_xiongb"] = "m_xiongb.swf";
         nameToFilename["m_xiongboss"] = "m_xiongbossv27.swf";
         nameToFilename["m_xiongc"] = "m_xiongc.swf";
         nameToFilename["m_xiongd"] = "m_xiongd.swf";
         nameToFilename["m_yerena"] = "m_yerena.swf";
         nameToFilename["m_yerenb"] = "m_yerenb.swf";
         nameToFilename["m_yerenboss"] = "m_yerenboss.swf";
         nameToFilename["m_yerenc"] = "m_yerenc.swf";
         nameToFilename["m_yerend"] = "m_yerend.swf";
         nameToFilename["m_jinshuhec"] = "m_jinshuhec.swf";
         nameToFilename["m_jinshuheb"] = "m_jinshuheb.swf";
         nameToFilename["m_mogua"] = "m_mogua.swf";
         nameToFilename["m_jinshuhea"] = "m_jinshuhea.swf";
         nameToFilename["m_guozia"] = "m_guozia.swf";
         nameToFilename["m_qingjiangjun"] = "m_qingjiangjun.swf";
         nameToFilename["m_qingjiangjuna"] = "m_qingjiangjuna.swf";
         nameToFilename["m_qingjiangjunb"] = "m_qingjiangjunb.swf";
         nameToFilename["m_qingjiangjunc"] = "m_qingjiangjunc.swf";
         nameToFilename["m_qingjiangjund"] = "m_qingjiangjund.swf";
         nameToFilename["m_qingjiangjune"] = "m_qingjiangjune.swf";
         nameToFilename["m_wuxingxiaoa"] = "m_wuxingxiaoa.swf";
         nameToFilename["m_wuxingxiaob"] = "m_wuxingxiaob.swf";
         nameToFilename["m_wuxingxiaoc"] = "m_wuxingxiaoc.swf";
         nameToFilename["m_wuxingxiaod"] = "m_wuxingxiaod.swf";
         nameToFilename["m_wuxingxiaoe"] = "m_wuxingxiaoe.swf";
         nameToFilename["m_awuxinghuo"] = "m_awuxinghuov111.swf";
         nameToFilename["m_awuxingjin"] = "m_awuxingjin.swf";
         nameToFilename["m_awuxingmu"] = "m_awuxingmu.swf";
         nameToFilename["m_awuxingshui"] = "m_awuxingshui.swf";
         nameToFilename["m_awuxingtu"] = "m_awuxingtu.swf";
         nameToFilename["m_shitoua"] = "m_shitoua.swf";
         nameToFilename["m_shitoub"] = "m_shitoubv14.swf";
         nameToFilename["m_niuguai"] = "m_niuguai.swf";
         nameToFilename["m_jiexieguaic"] = "m_jiexieguaic.swf";
         nameToFilename["m_longzhua"] = "m_longzhua.swf";
         nameToFilename["m_mofazhena"] = "m_mofazhena.swf";
         nameToFilename["m_jiexieguaiba"] = "m_jiexieguaibav33.swf";
         nameToFilename["m_jiexieguaibb"] = "m_jiexieguaibb.swf";
         nameToFilename["m_jiexieguaibc"] = "m_jiexieguaibc.swf";
         nameToFilename["m_jiexieguaibd"] = "m_jiexieguaibd.swf";
         nameToFilename["m_jiexieguaibe"] = "m_jiexieguaibe.swf";
         nameToFilename["m_yabadun"] = "m_yabadunv111.swf";
         nameToFilename["m_shuijinga"] = "m_shuijinga.swf";
         nameToFilename["m_guozib"] = "m_guozibv14.swf";
         nameToFilename["m_haijixieguaia"] = "m_haijixieguaiav14.swf";
         nameToFilename["m_haijixieguaib"] = "m_haijixieguaibv14.swf";
         nameToFilename["m_huaduoa"] = "m_huaduoav14.swf";
         nameToFilename["m_jiangshia"] = "m_jiangshiav14.swf";
         nameToFilename["m_jiexieguad"] = "m_jiexieguadv14.swf";
         nameToFilename["m_jiexieguada"] = "m_jiexieguadav14.swf";
         nameToFilename["m_jiexieguadb"] = "m_jiexieguadbv14.swf";
         nameToFilename["m_jiexieguadc"] = "m_jiexieguadcv14.swf";
         nameToFilename["m_jiexieguadd"] = "m_jiexieguaddv14.swf";
         nameToFilename["m_jiexieguade"] = "m_jiexieguadev14.swf";
         nameToFilename["m_jiguand"] = "m_jiguandv16.swf";
         nameToFilename["m_yijilaboss"] = "m_yijilabossv14.swf";
         nameToFilename["m_yuguaia"] = "m_yuguaiav14.swf";
         nameToFilename["m_zhangyua"] = "m_zhangyuav14.swf";
         nameToFilename["m_zhaomingdeng"] = "m_zhaomingdengv14.swf";
         nameToFilename["m_zhangyub"] = "m_zhangyubv16.swf";
         nameToFilename["m_yurenb"] = "m_yurenbv16.swf";
         nameToFilename["m_wulalaboss"] = "m_wulalabossv16.swf";
         nameToFilename["m_choushuibenga"] = "m_choushuibengav16.swf";
         nameToFilename["m_choushuibengb"] = "m_choushuibengbv16.swf";
         nameToFilename["m_fenshan"] = "m_fenshanv16.swf";
         nameToFilename["m_lianxiahao"] = "m_lianxiahaov16.swf";
         nameToFilename["m_jixieshouboss"] = "m_jixieshoubossv19.swf";
         nameToFilename["m_sishe"] = "m_sishev20.swf";
         nameToFilename["m_zishu"] = "m_zishuv191.swf";
         nameToFilename["m_moyang"] = "m_moyangv20.swf";
         nameToFilename["m_jianshiqi"] = "m_jianshiqiv21.swf";
         nameToFilename["m_jibaoqi"] = "m_jibaoqiv21.swf";
         nameToFilename["m_shenghou"] = "m_shenghouv21.swf";
         nameToFilename["m_maotu"] = "m_maotuv212.swf";
         nameToFilename["m_xugou"] = "m_xugouv22.swf";
         nameToFilename["m_wuma"] = "m_wumav22.swf";
         nameToFilename["m_wuke"] = "m_wukev211.swf";
         nameToFilename["m_wukeb"] = "m_wukebv21.swf";
         nameToFilename["m_yurenc"] = "m_yurencv21.swf";
         nameToFilename["m_yurend"] = "m_yurendv21.swf";
         nameToFilename["m_ci"] = "m_civ24.swf";
         nameToFilename["m_hushanhu"] = "m_hushanhuv24.swf";
         nameToFilename["m_jingling"] = "m_jinglingv24.swf";
         nameToFilename["m_paopao"] = "m_paopaov24.swf";
         nameToFilename["m_yutou"] = "m_yutouv24.swf";
         nameToFilename["m_yanjiang"] = "m_yanjiangv24.swf";
         nameToFilename["m_bossleili"] = "m_bossleiliv24.swf";
         nameToFilename["m_qiuji"] = "m_qiujiv27.swf";
         nameToFilename["m_beike"] = "m_beikev29.swf";
         nameToFilename["m_dsgsta"] = "m_dsgstav29.swf";
         nameToFilename["m_dsgstb"] = "m_dsgstbv29.swf";
         nameToFilename["m_dsgstc"] = "m_dsgstcv29.swf";
         nameToFilename["m_dsgstd"] = "m_dsgstdv29.swf";
         nameToFilename["m_yurenboss"] = "m_yurenbossv292.swf";
         nameToFilename["m_yurenbossb"] = "m_yurenbossbv29.swf";
         nameToFilename["m_jinglingb"] = "m_jinglingbv29.swf";
         nameToFilename["m_dsgstcb"] = "m_dsgstcbv29.swf";
         nameToFilename["m_yutoub"] = "m_yutoubv292.swf";
         nameToFilename["m_haizhu"] = "m_haizhuv295.swf";
         nameToFilename["m_munaiyi4"] = "m_munaiyi4v30.swf";
         nameToFilename["m_shamoairen"] = "m_shamoairenv30.swf";
         nameToFilename["m_tuolan"] = "m_tuolanv30.swf";
         nameToFilename["m_xianrenqiu"] = "m_xianrenqiuv30.swf";
         nameToFilename["m_xieziguai"] = "m_xieziguaiv30.swf";
         nameToFilename["m_cjgyhgd1"] = "m_cjgyhgd1v33.swf";
         nameToFilename["m_cjgyhgd2"] = "m_cjgyhgd2v30.swf";
         nameToFilename["m_cjgyhgd3"] = "m_cjgyhgd3v30.swf";
         nameToFilename["m_cjgyhgd4"] = "m_cjgyhgd4v30.swf";
         nameToFilename["m_cjgyhgd5"] = "m_cjgyhgd5v30.swf";
         nameToFilename["m_cjgyhgd6"] = "m_cjgyhgd6v30.swf";
         nameToFilename["m_cjgyhgd7"] = "m_cjgyhgd7v30.swf";
         nameToFilename["m_cjgyhgd8"] = "m_cjgyhgd8v30.swf";
         nameToFilename["m_cjgyhgd9"] = "m_cjgyhgd9v33.swf";
         nameToFilename["m_luoyideboss"] = "m_luoyidebossv30.swf";
         nameToFilename["m_yutouc"] = "m_yutoucv33.swf";
         nameToFilename["m_yinhu"] = "m_yinhuv33.swf";
         nameToFilename["m_xianrenqiub"] = "m_xianrenqiubv34.swf";
         nameToFilename["m_xiyi"] = "m_xiyiv34.swf";
         nameToFilename["m_shamoairenb"] = "m_shamoairenbv34.swf";
         nameToFilename["m_shachong"] = "m_shachongv34.swf";
         nameToFilename["m_ylnsboss"] = "m_ylnsbossv35.swf";
         nameToFilename["m_cjgyhgd13"] = "m_cjgyhgd13v34.swf";
         nameToFilename["m_cjgyhgd10"] = "m_cjgyhgd10v34.swf";
         nameToFilename["m_cjgyhgd11"] = "m_cjgyhgd11v34.swf";
         nameToFilename["m_cjgyhgd12"] = "m_cjgyhgd12v34.swf";
         nameToFilename["m_cjgyhgd14"] = "m_cjgyhgd14v35.swf";
         nameToFilename["m_cjgyhgd15"] = "m_cjgyhgd15v35.swf";
         nameToFilename["m_munaiyi3"] = "m_munaiyi3v35.swf";
         nameToFilename["m_munaiyi2"] = "m_munaiyi2v35.swf";
         nameToFilename["m_munaiyi1"] = "m_munaiyi1v35.swf";
         nameToFilename["m_daofengtanlang"] = "m_daofengtanlangv36.swf";
         nameToFilename["m_paxingzhe"] = "m_paxingzhev36.swf";
         nameToFilename["m_gebulind"] = "m_gebulindv36.swf";
         nameToFilename["m_lanluqiang"] = "m_lanluqiangv37.swf";
         nameToFilename["m_daofengtanlangb"] = "m_daofengtanlangbv38.swf";
         nameToFilename["m_jixiewushi"] = "m_jixiewushiv37.swf";
         nameToFilename["m_yxtuqizhe"] = "m_yxtuqizhev38.swf";
         nameToFilename["m_cjgwyxzc1"] = "m_cjgwyxzc1v38.swf";
         nameToFilename["m_cjgwyxzc2"] = "m_cjgwyxzc2v38.swf";
         nameToFilename["map_101_1"] = "map_101_1v36.swf";
         nameToFilename["map_102_1"] = "map_102_1v38.swf";
         nameToFilename["map_14_1"] = "map_14_1v35.swf";
         nameToFilename["mp_guanka12"] = "mp_guanka12v30.swf";
         nameToFilename["map_0_0"] = "map_0_0v446.swf";
         nameToFilename["map_0_1"] = "map_0_1.swf";
         nameToFilename["map_0_2"] = "map_0_2v191.swf";
         nameToFilename["map_0_3"] = "map_0_3v191.swf";
         nameToFilename["map_0_4"] = "map_0_4v291.swf";
         nameToFilename["map_0_5"] = "map_0_5v40.swf";
         nameToFilename["map_0_6"] = "map_0_6v29.swf";
         nameToFilename["map_1_1"] = "map_1_1.swf";
         nameToFilename["map_1_2"] = "map_1_2.swf";
         nameToFilename["map_1_3"] = "map_1_3.swf";
         nameToFilename["map_2_1"] = "map_2_1v12.swf";
         nameToFilename["map_2_2"] = "map_2_2.swf";
         nameToFilename["map_3_1"] = "map_3_1.swf";
         nameToFilename["map_3_2"] = "map_3_2v12.swf";
         nameToFilename["map_3_3"] = "map_3_3.swf";
         nameToFilename["map_4_1"] = "map_4_1v13.swf";
         nameToFilename["map_5_1"] = "map_5_1.swf";
         nameToFilename["map_5_2"] = "map_5_2.swf";
         nameToFilename["map_6_1"] = "map_6_1v30.swf";
         nameToFilename["map_7_1"] = "map_7_1v17.swf";
         nameToFilename["map_7_2"] = "map_7_2v16.swf";
         nameToFilename["map_9_2"] = "map_9_2v24.swf";
         nameToFilename["map_10_1"] = "map_10_1v29.swf";
         nameToFilename["map_8_1"] = "map_8_1v211.swf";
         nameToFilename["map_0_7"] = "map_0_7v323.swf";
         nameToFilename["map_0_8"] = "map_0_8v44.swf";
         nameToFilename["map_9_1"] = "map_9_1v24.swf";
         nameToFilename["map_12_1"] = "map_12_1v31.swf";
         nameToFilename["map_13_1"] = "map_13_1v34.swf";
         nameToFilename["zawu"] = "zawuv442.swf";
         nameToFilename["wupintubiao"] = "wupintubiaov43.swf";
         nameToFilename["ziti"] = "ziti.swf";
         nameToFilename["wanjiajiemian"] = "j_wanjiajiemianv443.swf";
         nameToFilename["xinshouzhishi"] = "j_xinshouzhishiv29.swf";
         nameToFilename["j_shiershengxiao"] = "j_shiershengxiaov40.swf";
         nameToFilename["j_bossxuetiao"] = "j_bossxuetiaov43.swf";
         nameToFilename["j_yxzc"] = "j_yxzcv42.swf";
         nameToFilename["yinxiao"] = "yinxiaov33.swf";
         nameToFilename["yinxiaogw"] = "yinxiaogwv33.swf";
         nameToFilename["yinxiaocw"] = "yinxiaocwv33.swf";
         nameToFilename["mp_cunzhuang"] = "mp_cunzhuangv36.swf";
         nameToFilename["mp_guanka1"] = "mp_guanka1.swf";
         nameToFilename["mp_guanka2"] = "mp_guanka2.swf";
         nameToFilename["mp_guanka3"] = "mp_guanka3.swf";
         nameToFilename["mp_guanka4"] = "mp_guanka4.swf";
         nameToFilename["mp_guanka5"] = "mp_guanka5.swf";
         nameToFilename["mp_guanka6"] = "mp_guanka6v141.swf";
         nameToFilename["mp_guanka7"] = "mp_guanka7v16.swf";
         nameToFilename["mp_guanka8"] = "mp_guanka8v21.swf";
         nameToFilename["mp_guanka10"] = "mp_guanka10v29.swf";
         nameToFilename["mp_shiliankongjian"] = "mp_shiliankongjian.swf";
         nameToFilename["mp_guanka02"] = "mp_guanka02v18.swf";
         nameToFilename["mp_guanka03"] = "mp_guanka03v19.swf";
         nameToFilename["mp_guanka04"] = "mp_guanka04v24.swf";
         nameToFilename["mp_guanka05"] = "mp_guanka05v272.swf";
         nameToFilename["mp_guanka06"] = "mp_guanka06v272.swf";
         nameToFilename["mp_guanka07"] = "mp_guanka07v31.swf";
         nameToFilename["mp_guanka9"] = "mp_guanka9v24.swf";
         nameToFilename["WuqiB_zhonghuopao"] = "WuqiB_zhonghuopaov33.swf";
         nameToFilename["WuqiB_zhiminglieshou"] = "WuqiB_zhiminglieshouv33.swf";
         nameToFilename["WuqiB_zhanshenzhilang"] = "WuqiB_zhanshenzhilangv33.swf";
         nameToFilename["WuqiB_xinshoupao"] = "WuqiB_xinshoupaov33.swf";
         nameToFilename["WuqiB_wwlzspao"] = "WuqiB_wwlzspaov33.swf";
         nameToFilename["WuqiB_wmhsdszp"] = "WuqiB_wmhsdszpv33.swf";
         nameToFilename["WuqiB_wmaerzywuqi"] = "WuqiB_wmaerzywuqiv33.swf";
         nameToFilename["WuqiB_whlsdszp"] = "WuqiB_whlsdszpv33.swf";
         nameToFilename["WuqiB_wcqzh"] = "WuqiB_wcqzhv33.swf";
         nameToFilename["WuqiB_wanheizywuqi"] = "WuqiB_wanheizywuqiv33.swf";
         nameToFilename["WuqiB_siyongbao"] = "WuqiB_siyongbaov33.swf";
         nameToFilename["WuqiB_sdszp"] = "WuqiB_sdszpv33.swf";
         nameToFilename["WuqiB_minmiezhe"] = "WuqiB_minmiezhev33.swf";
         nameToFilename["WuqiB_leitingxueyu"] = "WuqiB_leitingxueyuv33.swf";
         nameToFilename["WuqiB_lansejufeng"] = "WuqiB_lansejufengv33.swf";
         nameToFilename["sz_wtlzmqiang"] = "sz_wtlzmqiangv33.swf";
         nameToFilename["sz_wtlzgqiang"] = "sz_wtlzgqiangv33.swf";
         nameToFilename["WuqiM_zhuijizhelueying"] = "WuqiM_zhuijizhelueyingv33.swf";
         nameToFilename["WuqiM_zhuijizhelieyan"] = "WuqiM_zhuijizhelieyanv33.swf";
         nameToFilename["WuqiM_diyukongjian"] = "WuqiM_diyukongjianv33.swf";
         nameToFilename["WuqiL_liuxingfeipan"] = "WuqiL_liuxingfeipanv33.swf";
         nameToFilename["WuqiL_binglingdanat"] = "WuqiL_binglingdanatv33.swf";
         nameToFilename["WuqiH_xunhanzheshayu"] = "WuqiH_xunhanzheshayuv33.swf";
         nameToFilename["WuqiH_leimangjiying"] = "WuqiH_leimangjiyingv33.swf";
         nameToFilename["WuqiB_zhanshenzhiy"] = "WuqiB_zhanshenzhiyv33.swf";
         nameToFilename["WuqiB_yueguangjuezhe"] = "WuqiB_yueguangjuezhev33.swf";
         nameToFilename["WuqiB_xinshouqiang"] = "WuqiB_xinshouqiangv33.swf";
         nameToFilename["WuqiB_wlzsqiang"] = "WuqiB_wlzsqiangv33.swf";
         nameToFilename["WuqiB_sishendanhunqu"] = "WuqiB_sishendanhunquv33.swf";
         nameToFilename["WuqiB_sdszq"] = "WuqiB_sdszqv33.swf";
         nameToFilename["WuqiB_quzhuzhe"] = "WuqiB_quzhuzhev33.swf";
         nameToFilename["WuqiB_minmiezhiguang"] = "WuqiB_minmiezhiguangv33.swf";
         nameToFilename["WuqiB_mhsdszq"] = "WuqiB_mhsdszqv33.swf";
         nameToFilename["WuqiB_maerzywuqi"] = "WuqiB_maerzywuqiv33.swf";
         nameToFilename["WuqiB_leitinghuanying"] = "WuqiB_leitinghuanyingv33.swf";
         nameToFilename["WuqiB_jinguzhihun"] = "WuqiB_jinguzhihunv33.swf";
         nameToFilename["WuqiB_huohaijuezhe"] = "WuqiB_huohaijuezhev33.swf";
         nameToFilename["WuqiB_hlsdszq"] = "WuqiB_hlsdszqv33.swf";
         nameToFilename["WuqiB_cqzh"] = "WuqiB_cqzhv33.swf";
         nameToFilename["WuqiB_anheizywuqi"] = "WuqiB_anheizywuqiv33.swf";
         nameToFilename["WuqiB_wleimangjiying"] = "WuqiB_wleimangjiyingv38.swf";
         nameToFilename["WuqiB_wliuxingfeipan"] = "WuqiB_wliuxingfeipanv38.swf";
         nameToFilename["WuqiB_wzhaohuanzhe"] = "WuqiB_wzhaohuanzhev38.swf";
         nameToFilename["WuqiB_wzhuijizhelieyan"] = "WuqiB_wzhuijizhelieyanv38.swf";
         nameToFilename["WuqiB_wzhuijizhelueying"] = "WuqiB_wzhuijizhelueyingv38.swf";
         nameToFilename["sz_tlzmqiang"] = "sz_tlzmqiangv33.swf";
         nameToFilename["sz_tlzgqiang"] = "sz_tlzgqiangv33.swf";
         nameToFilename["sz_wmhsdkaijia"] = "sz_wmhsdkaijiav33.swf";
         nameToFilename["sz_wmhsdchibang"] = "sz_wmhsdchibangv33.swf";
         nameToFilename["sz_wmhsdxg"] = "sz_wmhsdxgv33.swf";
         nameToFilename["sz_mhsdkaijia"] = "sz_mhsdkaijiav33.swf";
         nameToFilename["sz_mhsdchibang"] = "sz_mhsdchibangv33.swf";
         nameToFilename["sz_mhsdxg"] = "sz_mhsdxgv33.swf";
         nameToFilename["chyhyz1"] = "chyhyz1v33.swf";
         nameToFilename["chyhyz2"] = "chyhyz2v33.swf";
         nameToFilename["chyhyz3"] = "chyhyz3v33.swf";
         nameToFilename["chyhyz4"] = "chyhyz4v33.swf";
         nameToFilename["chyhyz5"] = "chyhyz5v33.swf";
         nameToFilename["chqdzw"] = "chqdzwv33.swf";
         nameToFilename["chghdh"] = "chghdhv33.swf";
         nameToFilename["chgzsoz"] = "chgzsozv33.swf";
         nameToFilename["chgzzs"] = "chgzzsv33.swf";
         nameToFilename["chgzzj"] = "chgzzjv33.swf";
         nameToFilename["chhd"] = "chhdv33.swf";
         nameToFilename["chhhzn"] = "chhhznv33.swf";
         nameToFilename["chjijiazhixing"] = "chjijiazhixingv33.swf";
         nameToFilename["chjt"] = "chjtv33.swf";
         nameToFilename["chxg"] = "chxgv33.swf";
         nameToFilename["chyr"] = "chyrv33.swf";
         nameToFilename["chyhszs1"] = "chyhszs1v33.swf";
         nameToFilename["chyhszs2"] = "chyhszs2v33.swf";
         nameToFilename["chyhszs3"] = "chyhszs3v33.swf";
         nameToFilename["chyhszs4"] = "chyhszs4v33.swf";
         nameToFilename["chyhszs5"] = "chyhszs5v33.swf";
         nameToFilename["chyhtzz1"] = "chyhtzz1v33.swf";
         nameToFilename["chyhtzz2"] = "chyhtzz2v33.swf";
         nameToFilename["chyhtzz3"] = "chyhtzz3v33.swf";
         nameToFilename["chyhtzz4"] = "chyhtzz4v33.swf";
         nameToFilename["chyhtzz5"] = "chyhtzz5v33.swf";
         nameToFilename["chyhzs1"] = "chyhzs1v33.swf";
         nameToFilename["chyhzs2"] = "chyhzs2v33.swf";
         nameToFilename["chyhzs3"] = "chyhzs3v33.swf";
         nameToFilename["chyhzs4"] = "chyhzs4v33.swf";
         nameToFilename["chyhzs5"] = "chyhzs5v33.swf";
         nameToFilename["c_jijiaxiaobei"] = "c_jijiaxiaobeiv40.swf";
         nameToFilename["chjjyzn"] = "chjjyznv40.swf";
         nameToFilename["c_qinglong"] = "c_qinglongv42.swf";
         nameToFilename["dataxmlva"] = "dataxmlvav447.swf";
         nameToFilename["j_xuanfu"] = "j_xuanfuv322.swf";
         nameToFilename["j_sjljcz"] = "j_sjljczv442.swf";
         nameToFilename["j_czscw"] = "j_czscwv44.swf";
         nameToFilename["c_caomaoduolan"] = "c_caomaoduolanv21.swf";
         nameToFilename["c_aoluo"] = "c_aoluov21.swf";
         nameToFilename["c_maowu"] = "c_maowuv21.swf";
         nameToFilename["c_niduoshuiding"] = "c_niduoshuidingv21.swf";
         nameToFilename["c_xiaoshiya"] = "c_xiaoshiyav21.swf";
         nameToFilename["c_xiaohuowei"] = "c_xiaohuoweiv21.swf";
         nameToFilename["c_yuetu"] = "c_yuetuv211.swf";
         nameToFilename["c_baolizhangyu"] = "c_baolizhangyuv22.swf";
         nameToFilename["c_huomonv"] = "c_huomonvv221.swf";
         nameToFilename["c_bingmonv"] = "c_bingmonvv221.swf";
         nameToFilename["c_fenghuang"] = "c_fenghuangv272.swf";
         nameToFilename["c_milu"] = "c_miluv294.swf";
         nameToFilename["c_xiongmao"] = "c_xiongmaov30.swf";
         nameToFilename["c_shengxiaoma"] = "c_shengxiaomav32.swf";
         nameToFilename["c_anheizhizi"] = "c_anheizhiziv32.swf";
         nameToFilename["playerpanel"] = "j_playerpanelv34.swf";
         nameToFilename["bagpanel"] = "j_bagpanelv20.swf";
         nameToFilename["sxpanel"] = "j_sxpanelv44.swf";
         nameToFilename["insertpanel"] = "j_insertpanelv44.swf";
         nameToFilename["strengpanel"] = "j_strengpanelv22.swf";
         nameToFilename["npcpanel"] = "j_npcpanelv43.swf";
         nameToFilename["playertaskpanel"] = "j_playertaskpanelv32.swf";
         nameToFilename["taskmoveclip"] = "j_taskmoveclipv41.swf";
         nameToFilename["shoppanel"] = "j_shoppanelv33.swf";
         nameToFilename["othersc"] = "j_otherscv35.swf";
         nameToFilename["companel"] = "j_companelv33.swf";
         nameToFilename["wareroomPanel"] = "j_wareroomPanelv39.swf";
         nameToFilename["genechangepenel"] = "j_genChangePenelv40.swf";
         nameToFilename["signpanel"] = "j_signpanelv446.swf";
         nameToFilename["giftpanel"] = "j_giftpanelv447.swf";
         nameToFilename["chongwupanel"] = "j_chongwupanelv44.swf";
         nameToFilename["zqhd"] = "j_zqhdv211.swf";
         nameToFilename["vippanel"] = "j_vippanelv43.swf";
         nameToFilename["gqhd"] = "j_gqhdv297.swf";
         nameToFilename["everydaypanel"] = "j_everydaypanelv383.swf";
         nameToFilename["fbpanel"] = "j_fbpanelv443.swf";
         nameToFilename["sjpkpanel"] = "j_shujupkpanelv44.swf";
         nameToFilename["gxpanel"] = "j_gxshoppanelv26.swf";
         nameToFilename["zppanel"] = "j_zppanelv37.swf";
         nameToFilename["shippanel"] = "j_shippanelv43.swf";
         nameToFilename["petGj"] = "j_petGjv44.swf";
         nameToFilename["unionpanel"] = "j_unionpanelv44.swf";
         nameToFilename["unionvipanel"] = "j_unionvippanelv33.swf";
         nameToFilename["czhdpanel"] = "j_chzhhdpanelv32.swf";
         nameToFilename["unshoppanel"] = "j_unionShopPanelv322.swf";
         nameToFilename["unjsPanel"] = "j_unjsPanelv323.swf";
         nameToFilename["ts44"] = "ts_44v42.swf";
         nameToFilename["t_box"] = "t_boxv44.swf";
         nameToFilename["wmPanel"] = "j_wmPanelv33.swf";
         nameToFilename["pmodes1"] = "pmodes1v43.swf";
         nameToFilename["pmodes2"] = "pmodes2v43.swf";
         nameToFilename["online"] = "j_onlinejlv39.swf";
         nameToFilename["attPanel"] = "j_attpanelv40.swf";
         nameToFilename["zenfuPanel"] = "j_zenfupanelv37.swf";
         nameToFilename["treepanel"] = "treepanelv383.swf";
         nameToFilename["jjpanel"] = "j_jjpanelv446.swf";
         nameToFilename["tzpanel"] = "j_tzpanelv43.swf";
         nameToFilename["lxdlpanel"] = "j_lxdlpanelv442.swf";
         nameToFilename["jtzPanel"] = "j_jtzPanelv446.swf";
         nameToFilename["WuqiB_lsjzqiang"] = "WuqiB_lsjzqiangv382.swf";
         nameToFilename["WuqiB_lsjzpao"] = "WuqiB_lsjzpaov382.swf";
         nameToFilename["sz_wlsjzxg"] = "sz_wlsjzxgv382.swf";
         nameToFilename["sz_wlsjzkaijia"] = "sz_wlsjzkaijiav382.swf";
         nameToFilename["sz_wlsjzcb"] = "sz_wlsjzcbv382.swf";
         nameToFilename["sz_lsjzxg"] = "sz_lsjzxgv382.swf";
         nameToFilename["sz_lsjzkaijia"] = "sz_lsjzkaijiav382.swf";
         nameToFilename["sz_lsjzcb"] = "sz_lsjzcbv382.swf";
         nameToFilename["chylzz"] = "chylzzv382.swf";
         nameToFilename["m_kuilusiBoss"] = "m_kuilusiBossv383.swf";
         nameToFilename["m_yxzhuijizhe"] = "m_yxzhuijizhev383.swf";
         nameToFilename["m_yxzhuijizheb"] = "m_yxzhuijizhebv383.swf";
         nameToFilename["m_munaiyi6"] = "m_munaiyi6v39.swf";
         nameToFilename["m_munaiyi7"] = "m_munaiyi7v39.swf";
         nameToFilename["m_anubisiBoss"] = "m_anubisiBossv44.swf";
         nameToFilename["m_cjgyhgd16"] = "m_cjgyhgd16v39.swf";
         nameToFilename["m_cjgyhgd17"] = "m_cjgyhgd17v39.swf";
         nameToFilename["m_cjgyhgd18"] = "m_cjgyhgd18v39.swf";
         nameToFilename["m_cjgyhgd19"] = "m_cjgyhgd19v41.swf";
         nameToFilename["m_cjgyhgd20"] = "m_cjgyhgd20v41.swf";
         nameToFilename["m_cjgyhgd21"] = "m_cjgyhgd21v41.swf";
         nameToFilename["WuqiB_cyzmqiang"] = "WuqiB_cyzmqiangv39.swf";
         nameToFilename["WuqiB_cyzmpao"] = "WuqiB_cyzmpaov39.swf";
         nameToFilename["e_cyzmhuwan"] = "e_cyzmhuwanv39.swf";
         nameToFilename["e_cyzmkaijia"] = "e_cyzmkaijiav39.swf";
         nameToFilename["e_cyzmyaodai"] = "e_cyzmyaodaiv39.swf";
         nameToFilename["e_wcyzmhuwan"] = "e_wcyzmhuwanv39.swf";
         nameToFilename["e_wcyzmkaijia"] = "e_wcyzmkaijiav39.swf";
         nameToFilename["e_wcyzmyaodai"] = "e_wcyzmyaodaiv39.swf";
         nameToFilename["map_15_1"] = "map_15_1v39.swf";
         nameToFilename["map_16_1"] = "map_16_1v42.swf";
         nameToFilename["m_munaiyiBoss"] = "m_munaiyiBossv41.swf";
         nameToFilename["m_munaiyi5"] = "m_munaiyi5v41.swf";
         nameToFilename["m_chenlong"] = "m_chenlongv40.swf";
         nameToFilename["WuqiM_hbzy"] = "WuqiM_hbzyv41.swf";
         nameToFilename["WuqiM_whbzy"] = "WuqiM_whbzyv41.swf";
         nameToFilename["JijiaA_anheizhixing"] = "JijiaA_anheizhixingv41.swf";
         nameToFilename["m_mengma"] = "m_mengmav41.swf";
         nameToFilename["m_taiyangshenBoss"] = "m_taiyangshenBossv41.swf";
         nameToFilename["map_103_1"] = "map_103_1v42.swf";
         nameToFilename["m_balu"] = "m_baluv42.swf";
         nameToFilename["m_cjgwyxzc3"] = "m_cjgwyxzc3v42.swf";
         nameToFilename["m_cjgwyxzc4"] = "m_cjgwyxzc4v42.swf";
         nameToFilename["m_bazha"] = "m_bazhav42.swf";
         nameToFilename["m_gula"] = "m_gulav42.swf";
         nameToFilename["WuqiB_hyemqiang"] = "WuqiB_hyemqiangv42.swf";
         nameToFilename["WuqiB_hyempao"] = "WuqiB_hyempaov42.swf";
         nameToFilename["m_xiongerjiBoss"] = "m_xiongerjiBossv43.swf";
         nameToFilename["m_xiongdajiBoss"] = "m_xiongdajiBossv43.swf";
         nameToFilename["m_gcgw1"] = "m_gcgw1v43.swf";
         nameToFilename["m_gcgw2"] = "m_gcgw2v43.swf";
         nameToFilename["m_gcgw3"] = "m_gcgw3v43.swf";
         nameToFilename["m_gcgw4"] = "m_gcgw4v43.swf";
         nameToFilename["m_gcgw5"] = "m_gcgw5v43.swf";
         nameToFilename["m_gcgw6"] = "m_gcgw6v43.swf";
         nameToFilename["m_mmkuangsha"] = "m_mmkuangshav43.swf";
         nameToFilename["chjjzh"] = "chjjzhv43.swf";
         nameToFilename["WuqiB_shijiebeiqiang"] = "WuqiB_shijiebeiqiangv43.swf";
         nameToFilename["WuqiB_shijiebeipao"] = "WuqiB_shijiebeipaov43.swf";
         nameToFilename["map_0_9"] = "map_0_9v44.swf";
         nameToFilename["c_baihu"] = "c_baihuv44.swf";
         nameToFilename["chtuhao"] = "chtuhaov44.swf";
      }
      
      public static function getDataDocumentClass(param1:String) : MovieClip
      {
         return (loads[param1] as SwfLoader).getDisplayO();
      }
      
      public static function getFlaClass(param1:String, param2:String) : Object
      {
         return (loads[param1] as SwfLoader).getClass(param2);
      }
      
      public static function getSwfClass(param1:String) : Object
      {
         return (loads[allClassName[param1]] as SwfLoader).getClass(param1);
      }
      
      public static function getMcByClassName(param1:String) : MovieClip
      {
         var _loc2_:Class = getSwfClass(param1) as Class;
         return new _loc2_();
      }
      
      public function keYiUse() : Boolean
      {
         return this.isKeYiUse;
      }
      
      public function setLoadData(param1:Array) : void
      {
         var _loc2_:String = null;
         this.isKeYiUse = false;
         this._loadingname.length = 0;
         for each(_loc2_ in param1)
         {
            if(!loads.hasOwnProperty(_loc2_) && this._loadingname.indexOf(_loc2_) == -1)
            {
               this._loadingname.push(_loc2_);
            }
         }
         this.currentUrlNum = 0;
         this.totalUrlNum = this._loadingname.length;
      }
      
      private function loadData() : void
      {
         var _loc1_:String = this._loadingname[this.currentUrlNum];
         this.tempSwfLoaderm = new SwfLoader();
         this.tempSwfLoaderm.complete = this.loadCompleteHandle;
         this.tempSwfLoaderm.progress = this.loadProgressHandle;
         this.tempSwfLoaderm.loadSwf(nameToFilename[_loc1_]);
      }
      
      public function startLoadData() : void
      {
         if(this.totalUrlNum == 0)
         {
            this.callComplete();
            return;
         }
         var _loc1_:Class = ClassGet.getClassByName("jiazaijiemian");
         this.loadMcM = new LoaderProMcMain(new _loc1_());
         this.loadMcM.gmUpdate("" + (this.currentUrlNum + 1) + "/" + this.totalUrlNum,0);
         this.loadData();
      }
      
      public function startLoadDataJieM() : void
      {
         if(this.totalUrlNum == 0)
         {
            this.callComplete();
            return;
         }
         var _loc1_:Class = ClassGet.getClassByName("xiaojiazaijiemian");
         this.loadMcM = new LoaderProMcMin(new _loc1_());
         this.loadMcM.gmUpdate("" + (this.currentUrlNum + 1) + "/" + this.totalUrlNum,0);
         this.loadData();
      }
      
      public function loadProgressHandle(param1:int) : void
      {
         this.loadMcM.gmUpdate("" + (this.currentUrlNum + 1) + "/" + this.totalUrlNum,param1);
      }
      
      public function loadCompleteHandle(param1:Event) : void
      {
         LoaderManager.loads[this._loadingname[this.currentUrlNum]] = this.tempSwfLoaderm;
         this.tempSwfLoaderm = null;
         ++this.currentUrlNum;
         if(this.currentUrlNum <= this.totalUrlNum - 1)
         {
            this.loadData();
         }
         else
         {
            this.callComplete();
         }
      }
      
      public function gameExitStop() : void
      {
         this.totalUrlNum = 0;
         this._completeF = null;
      }
      
      private function callComplete() : void
      {
         var _loc1_:Function = null;
         this._loadingname.length = 0;
         this.isKeYiUse = true;
         if(this.loadMcM != null)
         {
            this.loadMcM.remove();
            this.loadMcM = null;
         }
         if(this._completeF != null)
         {
            _loc1_ = this._completeF;
            this._completeF = null;
            _loc1_();
            _loc1_ = null;
         }
      }
      
      public function set completeF(param1:Function) : void
      {
         this._completeF = param1;
      }
   }
}

