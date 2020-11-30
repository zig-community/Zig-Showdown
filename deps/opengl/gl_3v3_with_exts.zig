﻿const std = @import("std");
const log = std.log.scoped(.OpenGL);

pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLclampx = i32;
pub const GLsizei = c_int;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLeglClientBufferEXT = void;
pub const GLeglImageOES = void;
pub const GLchar = u8;
pub const GLcharARB = u8;

pub const GLhandleARB = if (std.builtin.os.tag == .macos) *c_void else c_uint;

pub const GLhalf = u16;
pub const GLhalfARB = u16;
pub const GLfixed = i32;
pub const GLintptr = usize;
pub const GLintptrARB = usize;
pub const GLsizeiptr = isize;
pub const GLsizeiptrARB = isize;
pub const GLint64 = i64;
pub const GLint64EXT = i64;
pub const GLuint64 = u64;
pub const GLuint64EXT = u64;

pub const GLsync = *opaque {};

pub const _cl_context = opaque {};
pub const _cl_event = opaque {};

pub const GLDEBUGPROC = fn (source: GLenum, type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: *c_void) callconv(.C) void;
pub const GLDEBUGPROCARB = fn (source: GLenum, type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: *c_void) callconv(.C) void;
pub const GLDEBUGPROCKHR = fn (source: GLenum, type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: *c_void) callconv(.C) void;

pub const GLDEBUGPROCAMD = fn (id: GLuint, category: GLenum, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: *c_void) callconv(.C) void;

pub const GLhalfNV = u16;
pub const GLvdpauSurfaceNV = GLintptr;
pub const GLVULKANPROCNV = fn (void) callconv(.C) void;

pub const DEPTH_BUFFER_BIT = 0x00000100;
pub const STENCIL_BUFFER_BIT = 0x00000400;
pub const COLOR_BUFFER_BIT = 0x00004000;
pub const FALSE = 0;
pub const TRUE = 1;
pub const POINTS = 0x0000;
pub const LINES = 0x0001;
pub const LINE_LOOP = 0x0002;
pub const LINE_STRIP = 0x0003;
pub const TRIANGLES = 0x0004;
pub const TRIANGLE_STRIP = 0x0005;
pub const TRIANGLE_FAN = 0x0006;
pub const NEVER = 0x0200;
pub const LESS = 0x0201;
pub const EQUAL = 0x0202;
pub const LEQUAL = 0x0203;
pub const GREATER = 0x0204;
pub const NOTEQUAL = 0x0205;
pub const GEQUAL = 0x0206;
pub const ALWAYS = 0x0207;
pub const ZERO = 0;
pub const ONE = 1;
pub const SRC_COLOR = 0x0300;
pub const ONE_MINUS_SRC_COLOR = 0x0301;
pub const SRC_ALPHA = 0x0302;
pub const ONE_MINUS_SRC_ALPHA = 0x0303;
pub const DST_ALPHA = 0x0304;
pub const ONE_MINUS_DST_ALPHA = 0x0305;
pub const DST_COLOR = 0x0306;
pub const ONE_MINUS_DST_COLOR = 0x0307;
pub const SRC_ALPHA_SATURATE = 0x0308;
pub const NONE = 0;
pub const FRONT_LEFT = 0x0400;
pub const FRONT_RIGHT = 0x0401;
pub const BACK_LEFT = 0x0402;
pub const BACK_RIGHT = 0x0403;
pub const FRONT = 0x0404;
pub const BACK = 0x0405;
pub const LEFT = 0x0406;
pub const RIGHT = 0x0407;
pub const FRONT_AND_BACK = 0x0408;
pub const NO_ERROR = 0;
pub const INVALID_ENUM = 0x0500;
pub const INVALID_VALUE = 0x0501;
pub const INVALID_OPERATION = 0x0502;
pub const OUT_OF_MEMORY = 0x0505;
pub const CW = 0x0900;
pub const CCW = 0x0901;
pub const POINT_SIZE = 0x0B11;
pub const POINT_SIZE_RANGE = 0x0B12;
pub const POINT_SIZE_GRANULARITY = 0x0B13;
pub const LINE_SMOOTH = 0x0B20;
pub const LINE_WIDTH = 0x0B21;
pub const LINE_WIDTH_RANGE = 0x0B22;
pub const LINE_WIDTH_GRANULARITY = 0x0B23;
pub const POLYGON_MODE = 0x0B40;
pub const POLYGON_SMOOTH = 0x0B41;
pub const CULL_FACE = 0x0B44;
pub const CULL_FACE_MODE = 0x0B45;
pub const FRONT_FACE = 0x0B46;
pub const DEPTH_RANGE = 0x0B70;
pub const DEPTH_TEST = 0x0B71;
pub const DEPTH_WRITEMASK = 0x0B72;
pub const DEPTH_CLEAR_VALUE = 0x0B73;
pub const DEPTH_FUNC = 0x0B74;
pub const STENCIL_TEST = 0x0B90;
pub const STENCIL_CLEAR_VALUE = 0x0B91;
pub const STENCIL_FUNC = 0x0B92;
pub const STENCIL_VALUE_MASK = 0x0B93;
pub const STENCIL_FAIL = 0x0B94;
pub const STENCIL_PASS_DEPTH_FAIL = 0x0B95;
pub const STENCIL_PASS_DEPTH_PASS = 0x0B96;
pub const STENCIL_REF = 0x0B97;
pub const STENCIL_WRITEMASK = 0x0B98;
pub const VIEWPORT = 0x0BA2;
pub const DITHER = 0x0BD0;
pub const BLEND_DST = 0x0BE0;
pub const BLEND_SRC = 0x0BE1;
pub const BLEND = 0x0BE2;
pub const LOGIC_OP_MODE = 0x0BF0;
pub const DRAW_BUFFER = 0x0C01;
pub const READ_BUFFER = 0x0C02;
pub const SCISSOR_BOX = 0x0C10;
pub const SCISSOR_TEST = 0x0C11;
pub const COLOR_CLEAR_VALUE = 0x0C22;
pub const COLOR_WRITEMASK = 0x0C23;
pub const DOUBLEBUFFER = 0x0C32;
pub const STEREO = 0x0C33;
pub const LINE_SMOOTH_HINT = 0x0C52;
pub const POLYGON_SMOOTH_HINT = 0x0C53;
pub const UNPACK_SWAP_BYTES = 0x0CF0;
pub const UNPACK_LSB_FIRST = 0x0CF1;
pub const UNPACK_ROW_LENGTH = 0x0CF2;
pub const UNPACK_SKIP_ROWS = 0x0CF3;
pub const UNPACK_SKIP_PIXELS = 0x0CF4;
pub const UNPACK_ALIGNMENT = 0x0CF5;
pub const PACK_SWAP_BYTES = 0x0D00;
pub const PACK_LSB_FIRST = 0x0D01;
pub const PACK_ROW_LENGTH = 0x0D02;
pub const PACK_SKIP_ROWS = 0x0D03;
pub const PACK_SKIP_PIXELS = 0x0D04;
pub const PACK_ALIGNMENT = 0x0D05;
pub const MAX_TEXTURE_SIZE = 0x0D33;
pub const MAX_VIEWPORT_DIMS = 0x0D3A;
pub const SUBPIXEL_BITS = 0x0D50;
pub const TEXTURE_1D = 0x0DE0;
pub const TEXTURE_2D = 0x0DE1;
pub const TEXTURE_WIDTH = 0x1000;
pub const TEXTURE_HEIGHT = 0x1001;
pub const TEXTURE_BORDER_COLOR = 0x1004;
pub const DONT_CARE = 0x1100;
pub const FASTEST = 0x1101;
pub const NICEST = 0x1102;
pub const BYTE = 0x1400;
pub const UNSIGNED_BYTE = 0x1401;
pub const SHORT = 0x1402;
pub const UNSIGNED_SHORT = 0x1403;
pub const INT = 0x1404;
pub const UNSIGNED_INT = 0x1405;
pub const FLOAT = 0x1406;
pub const CLEAR = 0x1500;
pub const AND = 0x1501;
pub const AND_REVERSE = 0x1502;
pub const COPY = 0x1503;
pub const AND_INVERTED = 0x1504;
pub const NOOP = 0x1505;
pub const XOR = 0x1506;
pub const OR = 0x1507;
pub const NOR = 0x1508;
pub const EQUIV = 0x1509;
pub const INVERT = 0x150A;
pub const OR_REVERSE = 0x150B;
pub const COPY_INVERTED = 0x150C;
pub const OR_INVERTED = 0x150D;
pub const NAND = 0x150E;
pub const SET = 0x150F;
pub const TEXTURE = 0x1702;
pub const COLOR = 0x1800;
pub const DEPTH = 0x1801;
pub const STENCIL = 0x1802;
pub const STENCIL_INDEX = 0x1901;
pub const DEPTH_COMPONENT = 0x1902;
pub const RED = 0x1903;
pub const GREEN = 0x1904;
pub const BLUE = 0x1905;
pub const ALPHA = 0x1906;
pub const RGB = 0x1907;
pub const RGBA = 0x1908;
pub const POINT = 0x1B00;
pub const LINE = 0x1B01;
pub const FILL = 0x1B02;
pub const KEEP = 0x1E00;
pub const REPLACE = 0x1E01;
pub const INCR = 0x1E02;
pub const DECR = 0x1E03;
pub const VENDOR = 0x1F00;
pub const RENDERER = 0x1F01;
pub const VERSION = 0x1F02;
pub const EXTENSIONS = 0x1F03;
pub const NEAREST = 0x2600;
pub const LINEAR = 0x2601;
pub const NEAREST_MIPMAP_NEAREST = 0x2700;
pub const LINEAR_MIPMAP_NEAREST = 0x2701;
pub const NEAREST_MIPMAP_LINEAR = 0x2702;
pub const LINEAR_MIPMAP_LINEAR = 0x2703;
pub const TEXTURE_MAG_FILTER = 0x2800;
pub const TEXTURE_MIN_FILTER = 0x2801;
pub const TEXTURE_WRAP_S = 0x2802;
pub const TEXTURE_WRAP_T = 0x2803;
pub const REPEAT = 0x2901;
pub const COLOR_LOGIC_OP = 0x0BF2;
pub const POLYGON_OFFSET_UNITS = 0x2A00;
pub const POLYGON_OFFSET_POINT = 0x2A01;
pub const POLYGON_OFFSET_LINE = 0x2A02;
pub const POLYGON_OFFSET_FILL = 0x8037;
pub const POLYGON_OFFSET_FACTOR = 0x8038;
pub const TEXTURE_BINDING_1D = 0x8068;
pub const TEXTURE_BINDING_2D = 0x8069;
pub const TEXTURE_INTERNAL_FORMAT = 0x1003;
pub const TEXTURE_RED_SIZE = 0x805C;
pub const TEXTURE_GREEN_SIZE = 0x805D;
pub const TEXTURE_BLUE_SIZE = 0x805E;
pub const TEXTURE_ALPHA_SIZE = 0x805F;
pub const DOUBLE = 0x140A;
pub const PROXY_TEXTURE_1D = 0x8063;
pub const PROXY_TEXTURE_2D = 0x8064;
pub const R3_G3_B2 = 0x2A10;
pub const RGB4 = 0x804F;
pub const RGB5 = 0x8050;
pub const RGB8 = 0x8051;
pub const RGB10 = 0x8052;
pub const RGB12 = 0x8053;
pub const RGB16 = 0x8054;
pub const RGBA2 = 0x8055;
pub const RGBA4 = 0x8056;
pub const RGB5_A1 = 0x8057;
pub const RGBA8 = 0x8058;
pub const RGB10_A2 = 0x8059;
pub const RGBA12 = 0x805A;
pub const RGBA16 = 0x805B;
pub const UNSIGNED_BYTE_3_3_2 = 0x8032;
pub const UNSIGNED_SHORT_4_4_4_4 = 0x8033;
pub const UNSIGNED_SHORT_5_5_5_1 = 0x8034;
pub const UNSIGNED_INT_8_8_8_8 = 0x8035;
pub const UNSIGNED_INT_10_10_10_2 = 0x8036;
pub const TEXTURE_BINDING_3D = 0x806A;
pub const PACK_SKIP_IMAGES = 0x806B;
pub const PACK_IMAGE_HEIGHT = 0x806C;
pub const UNPACK_SKIP_IMAGES = 0x806D;
pub const UNPACK_IMAGE_HEIGHT = 0x806E;
pub const TEXTURE_3D = 0x806F;
pub const PROXY_TEXTURE_3D = 0x8070;
pub const TEXTURE_DEPTH = 0x8071;
pub const TEXTURE_WRAP_R = 0x8072;
pub const MAX_3D_TEXTURE_SIZE = 0x8073;
pub const UNSIGNED_BYTE_2_3_3_REV = 0x8362;
pub const UNSIGNED_SHORT_5_6_5 = 0x8363;
pub const UNSIGNED_SHORT_5_6_5_REV = 0x8364;
pub const UNSIGNED_SHORT_4_4_4_4_REV = 0x8365;
pub const UNSIGNED_SHORT_1_5_5_5_REV = 0x8366;
pub const UNSIGNED_INT_8_8_8_8_REV = 0x8367;
pub const UNSIGNED_INT_2_10_10_10_REV = 0x8368;
pub const BGR = 0x80E0;
pub const BGRA = 0x80E1;
pub const MAX_ELEMENTS_VERTICES = 0x80E8;
pub const MAX_ELEMENTS_INDICES = 0x80E9;
pub const CLAMP_TO_EDGE = 0x812F;
pub const TEXTURE_MIN_LOD = 0x813A;
pub const TEXTURE_MAX_LOD = 0x813B;
pub const TEXTURE_BASE_LEVEL = 0x813C;
pub const TEXTURE_MAX_LEVEL = 0x813D;
pub const SMOOTH_POINT_SIZE_RANGE = 0x0B12;
pub const SMOOTH_POINT_SIZE_GRANULARITY = 0x0B13;
pub const SMOOTH_LINE_WIDTH_RANGE = 0x0B22;
pub const SMOOTH_LINE_WIDTH_GRANULARITY = 0x0B23;
pub const ALIASED_LINE_WIDTH_RANGE = 0x846E;
pub const TEXTURE0 = 0x84C0;
pub const TEXTURE1 = 0x84C1;
pub const TEXTURE2 = 0x84C2;
pub const TEXTURE3 = 0x84C3;
pub const TEXTURE4 = 0x84C4;
pub const TEXTURE5 = 0x84C5;
pub const TEXTURE6 = 0x84C6;
pub const TEXTURE7 = 0x84C7;
pub const TEXTURE8 = 0x84C8;
pub const TEXTURE9 = 0x84C9;
pub const TEXTURE10 = 0x84CA;
pub const TEXTURE11 = 0x84CB;
pub const TEXTURE12 = 0x84CC;
pub const TEXTURE13 = 0x84CD;
pub const TEXTURE14 = 0x84CE;
pub const TEXTURE15 = 0x84CF;
pub const TEXTURE16 = 0x84D0;
pub const TEXTURE17 = 0x84D1;
pub const TEXTURE18 = 0x84D2;
pub const TEXTURE19 = 0x84D3;
pub const TEXTURE20 = 0x84D4;
pub const TEXTURE21 = 0x84D5;
pub const TEXTURE22 = 0x84D6;
pub const TEXTURE23 = 0x84D7;
pub const TEXTURE24 = 0x84D8;
pub const TEXTURE25 = 0x84D9;
pub const TEXTURE26 = 0x84DA;
pub const TEXTURE27 = 0x84DB;
pub const TEXTURE28 = 0x84DC;
pub const TEXTURE29 = 0x84DD;
pub const TEXTURE30 = 0x84DE;
pub const TEXTURE31 = 0x84DF;
pub const ACTIVE_TEXTURE = 0x84E0;
pub const MULTISAMPLE = 0x809D;
pub const SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
pub const SAMPLE_ALPHA_TO_ONE = 0x809F;
pub const SAMPLE_COVERAGE = 0x80A0;
pub const SAMPLE_BUFFERS = 0x80A8;
pub const SAMPLES = 0x80A9;
pub const SAMPLE_COVERAGE_VALUE = 0x80AA;
pub const SAMPLE_COVERAGE_INVERT = 0x80AB;
pub const TEXTURE_CUBE_MAP = 0x8513;
pub const TEXTURE_BINDING_CUBE_MAP = 0x8514;
pub const TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
pub const TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
pub const TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
pub const TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
pub const TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
pub const PROXY_TEXTURE_CUBE_MAP = 0x851B;
pub const MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
pub const COMPRESSED_RGB = 0x84ED;
pub const COMPRESSED_RGBA = 0x84EE;
pub const TEXTURE_COMPRESSION_HINT = 0x84EF;
pub const TEXTURE_COMPRESSED_IMAGE_SIZE = 0x86A0;
pub const TEXTURE_COMPRESSED = 0x86A1;
pub const NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
pub const COMPRESSED_TEXTURE_FORMATS = 0x86A3;
pub const CLAMP_TO_BORDER = 0x812D;
pub const INT_2_10_10_10_REV = 0x8D9F;
pub const TIMESTAMP = 0x8E28;
pub const TIME_ELAPSED = 0x88BF;
pub const TEXTURE_SWIZZLE_RGBA = 0x8E46;
pub const TEXTURE_SWIZZLE_A = 0x8E45;
pub const TEXTURE_SWIZZLE_B = 0x8E44;
pub const TEXTURE_SWIZZLE_G = 0x8E43;
pub const TEXTURE_SWIZZLE_R = 0x8E42;
pub const RGB10_A2UI = 0x906F;
pub const BLEND_DST_RGB = 0x80C8;
pub const BLEND_SRC_RGB = 0x80C9;
pub const BLEND_DST_ALPHA = 0x80CA;
pub const BLEND_SRC_ALPHA = 0x80CB;
pub const POINT_FADE_THRESHOLD_SIZE = 0x8128;
pub const DEPTH_COMPONENT16 = 0x81A5;
pub const DEPTH_COMPONENT24 = 0x81A6;
pub const DEPTH_COMPONENT32 = 0x81A7;
pub const MIRRORED_REPEAT = 0x8370;
pub const MAX_TEXTURE_LOD_BIAS = 0x84FD;
pub const TEXTURE_LOD_BIAS = 0x8501;
pub const INCR_WRAP = 0x8507;
pub const DECR_WRAP = 0x8508;
pub const TEXTURE_DEPTH_SIZE = 0x884A;
pub const TEXTURE_COMPARE_MODE = 0x884C;
pub const TEXTURE_COMPARE_FUNC = 0x884D;
pub const SAMPLER_BINDING = 0x8919;
pub const ANY_SAMPLES_PASSED = 0x8C2F;
pub const MAX_DUAL_SOURCE_DRAW_BUFFERS = 0x88FC;
pub const ONE_MINUS_SRC1_ALPHA = 0x88FB;
pub const ONE_MINUS_SRC1_COLOR = 0x88FA;
pub const SRC1_COLOR = 0x88F9;
pub const VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;
pub const MAX_INTEGER_SAMPLES = 0x9110;
pub const MAX_DEPTH_TEXTURE_SAMPLES = 0x910F;
pub const MAX_COLOR_TEXTURE_SAMPLES = 0x910E;
pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D;
pub const INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910C;
pub const SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910B;
pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910A;
pub const INT_SAMPLER_2D_MULTISAMPLE = 0x9109;
pub const SAMPLER_2D_MULTISAMPLE = 0x9108;
pub const TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107;
pub const TEXTURE_SAMPLES = 0x9106;
pub const TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105;
pub const TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104;
pub const PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103;
pub const TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9102;
pub const PROXY_TEXTURE_2D_MULTISAMPLE = 0x9101;
pub const TEXTURE_2D_MULTISAMPLE = 0x9100;
pub const MAX_SAMPLE_MASK_WORDS = 0x8E59;
pub const SAMPLE_MASK_VALUE = 0x8E52;
pub const SAMPLE_MASK = 0x8E51;
pub const SAMPLE_POSITION = 0x8E50;
pub const SYNC_FLUSH_COMMANDS_BIT = 0x00000001;
pub const TIMEOUT_IGNORED = 0xFFFFFFFFFFFFFFFF;
pub const WAIT_FAILED = 0x911D;
pub const CONDITION_SATISFIED = 0x911C;
pub const TIMEOUT_EXPIRED = 0x911B;
pub const ALREADY_SIGNALED = 0x911A;
pub const SIGNALED = 0x9119;
pub const UNSIGNALED = 0x9118;
pub const SYNC_GPU_COMMANDS_COMPLETE = 0x9117;
pub const BLEND_COLOR = 0x8005;
pub const BLEND_EQUATION = 0x8009;
pub const CONSTANT_COLOR = 0x8001;
pub const ONE_MINUS_CONSTANT_COLOR = 0x8002;
pub const CONSTANT_ALPHA = 0x8003;
pub const ONE_MINUS_CONSTANT_ALPHA = 0x8004;
pub const FUNC_ADD = 0x8006;
pub const FUNC_REVERSE_SUBTRACT = 0x800B;
pub const FUNC_SUBTRACT = 0x800A;
pub const MIN = 0x8007;
pub const MAX = 0x8008;
pub const BUFFER_SIZE = 0x8764;
pub const BUFFER_USAGE = 0x8765;
pub const QUERY_COUNTER_BITS = 0x8864;
pub const CURRENT_QUERY = 0x8865;
pub const QUERY_RESULT = 0x8866;
pub const QUERY_RESULT_AVAILABLE = 0x8867;
pub const ARRAY_BUFFER = 0x8892;
pub const ELEMENT_ARRAY_BUFFER = 0x8893;
pub const ARRAY_BUFFER_BINDING = 0x8894;
pub const ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;
pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
pub const READ_ONLY = 0x88B8;
pub const WRITE_ONLY = 0x88B9;
pub const READ_WRITE = 0x88BA;
pub const BUFFER_ACCESS = 0x88BB;
pub const BUFFER_MAPPED = 0x88BC;
pub const BUFFER_MAP_POINTER = 0x88BD;
pub const STREAM_DRAW = 0x88E0;
pub const STREAM_READ = 0x88E1;
pub const STREAM_COPY = 0x88E2;
pub const STATIC_DRAW = 0x88E4;
pub const STATIC_READ = 0x88E5;
pub const STATIC_COPY = 0x88E6;
pub const DYNAMIC_DRAW = 0x88E8;
pub const DYNAMIC_READ = 0x88E9;
pub const DYNAMIC_COPY = 0x88EA;
pub const SAMPLES_PASSED = 0x8914;
pub const SRC1_ALPHA = 0x8589;
pub const SYNC_FENCE = 0x9116;
pub const SYNC_FLAGS = 0x9115;
pub const SYNC_STATUS = 0x9114;
pub const SYNC_CONDITION = 0x9113;
pub const OBJECT_TYPE = 0x9112;
pub const MAX_SERVER_WAIT_TIMEOUT = 0x9111;
pub const TEXTURE_CUBE_MAP_SEAMLESS = 0x884F;
pub const PROVOKING_VERTEX = 0x8E4F;
pub const LAST_VERTEX_CONVENTION = 0x8E4E;
pub const FIRST_VERTEX_CONVENTION = 0x8E4D;
pub const QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4C;
pub const DEPTH_CLAMP = 0x864F;
pub const CONTEXT_PROFILE_MASK = 0x9126;
pub const MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125;
pub const MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124;
pub const MAX_GEOMETRY_INPUT_COMPONENTS = 0x9123;
pub const MAX_VERTEX_OUTPUT_COMPONENTS = 0x9122;
pub const BLEND_EQUATION_RGB = 0x8009;
pub const VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
pub const VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
pub const VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
pub const VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
pub const CURRENT_VERTEX_ATTRIB = 0x8626;
pub const VERTEX_PROGRAM_POINT_SIZE = 0x8642;
pub const VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
pub const STENCIL_BACK_FUNC = 0x8800;
pub const STENCIL_BACK_FAIL = 0x8801;
pub const STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
pub const STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
pub const MAX_DRAW_BUFFERS = 0x8824;
pub const DRAW_BUFFER0 = 0x8825;
pub const DRAW_BUFFER1 = 0x8826;
pub const DRAW_BUFFER2 = 0x8827;
pub const DRAW_BUFFER3 = 0x8828;
pub const DRAW_BUFFER4 = 0x8829;
pub const DRAW_BUFFER5 = 0x882A;
pub const DRAW_BUFFER6 = 0x882B;
pub const DRAW_BUFFER7 = 0x882C;
pub const DRAW_BUFFER8 = 0x882D;
pub const DRAW_BUFFER9 = 0x882E;
pub const DRAW_BUFFER10 = 0x882F;
pub const DRAW_BUFFER11 = 0x8830;
pub const DRAW_BUFFER12 = 0x8831;
pub const DRAW_BUFFER13 = 0x8832;
pub const DRAW_BUFFER14 = 0x8833;
pub const DRAW_BUFFER15 = 0x8834;
pub const BLEND_EQUATION_ALPHA = 0x883D;
pub const MAX_VERTEX_ATTRIBS = 0x8869;
pub const VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
pub const MAX_TEXTURE_IMAGE_UNITS = 0x8872;
pub const FRAGMENT_SHADER = 0x8B30;
pub const VERTEX_SHADER = 0x8B31;
pub const MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
pub const MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
pub const MAX_VARYING_FLOATS = 0x8B4B;
pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
pub const SHADER_TYPE = 0x8B4F;
pub const FLOAT_VEC2 = 0x8B50;
pub const FLOAT_VEC3 = 0x8B51;
pub const FLOAT_VEC4 = 0x8B52;
pub const INT_VEC2 = 0x8B53;
pub const INT_VEC3 = 0x8B54;
pub const INT_VEC4 = 0x8B55;
pub const BOOL = 0x8B56;
pub const BOOL_VEC2 = 0x8B57;
pub const BOOL_VEC3 = 0x8B58;
pub const BOOL_VEC4 = 0x8B59;
pub const FLOAT_MAT2 = 0x8B5A;
pub const FLOAT_MAT3 = 0x8B5B;
pub const FLOAT_MAT4 = 0x8B5C;
pub const SAMPLER_1D = 0x8B5D;
pub const SAMPLER_2D = 0x8B5E;
pub const SAMPLER_3D = 0x8B5F;
pub const SAMPLER_CUBE = 0x8B60;
pub const SAMPLER_1D_SHADOW = 0x8B61;
pub const SAMPLER_2D_SHADOW = 0x8B62;
pub const DELETE_STATUS = 0x8B80;
pub const COMPILE_STATUS = 0x8B81;
pub const LINK_STATUS = 0x8B82;
pub const VALIDATE_STATUS = 0x8B83;
pub const INFO_LOG_LENGTH = 0x8B84;
pub const ATTACHED_SHADERS = 0x8B85;
pub const ACTIVE_UNIFORMS = 0x8B86;
pub const ACTIVE_UNIFORM_MAX_LENGTH = 0x8B87;
pub const SHADER_SOURCE_LENGTH = 0x8B88;
pub const ACTIVE_ATTRIBUTES = 0x8B89;
pub const ACTIVE_ATTRIBUTE_MAX_LENGTH = 0x8B8A;
pub const FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
pub const SHADING_LANGUAGE_VERSION = 0x8B8C;
pub const CURRENT_PROGRAM = 0x8B8D;
pub const POINT_SPRITE_COORD_ORIGIN = 0x8CA0;
pub const LOWER_LEFT = 0x8CA1;
pub const UPPER_LEFT = 0x8CA2;
pub const STENCIL_BACK_REF = 0x8CA3;
pub const STENCIL_BACK_VALUE_MASK = 0x8CA4;
pub const STENCIL_BACK_WRITEMASK = 0x8CA5;
pub const MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1;
pub const MAX_GEOMETRY_OUTPUT_VERTICES = 0x8DE0;
pub const MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDF;
pub const GEOMETRY_OUTPUT_TYPE = 0x8918;
pub const PIXEL_PACK_BUFFER = 0x88EB;
pub const PIXEL_UNPACK_BUFFER = 0x88EC;
pub const PIXEL_PACK_BUFFER_BINDING = 0x88ED;
pub const PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
pub const FLOAT_MAT2x3 = 0x8B65;
pub const FLOAT_MAT2x4 = 0x8B66;
pub const FLOAT_MAT3x2 = 0x8B67;
pub const FLOAT_MAT3x4 = 0x8B68;
pub const FLOAT_MAT4x2 = 0x8B69;
pub const FLOAT_MAT4x3 = 0x8B6A;
pub const SRGB = 0x8C40;
pub const SRGB8 = 0x8C41;
pub const SRGB_ALPHA = 0x8C42;
pub const SRGB8_ALPHA8 = 0x8C43;
pub const COMPRESSED_SRGB = 0x8C48;
pub const COMPRESSED_SRGB_ALPHA = 0x8C49;
pub const GEOMETRY_INPUT_TYPE = 0x8917;
pub const GEOMETRY_VERTICES_OUT = 0x8916;
pub const GEOMETRY_SHADER = 0x8DD9;
pub const FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8;
pub const FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7;
pub const MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29;
pub const PROGRAM_POINT_SIZE = 0x8642;
pub const COMPARE_REF_TO_TEXTURE = 0x884E;
pub const CLIP_DISTANCE0 = 0x3000;
pub const CLIP_DISTANCE1 = 0x3001;
pub const CLIP_DISTANCE2 = 0x3002;
pub const CLIP_DISTANCE3 = 0x3003;
pub const CLIP_DISTANCE4 = 0x3004;
pub const CLIP_DISTANCE5 = 0x3005;
pub const CLIP_DISTANCE6 = 0x3006;
pub const CLIP_DISTANCE7 = 0x3007;
pub const MAX_CLIP_DISTANCES = 0x0D32;
pub const MAJOR_VERSION = 0x821B;
pub const MINOR_VERSION = 0x821C;
pub const NUM_EXTENSIONS = 0x821D;
pub const CONTEXT_FLAGS = 0x821E;
pub const COMPRESSED_RED = 0x8225;
pub const COMPRESSED_RG = 0x8226;
pub const CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x00000001;
pub const RGBA32F = 0x8814;
pub const RGB32F = 0x8815;
pub const RGBA16F = 0x881A;
pub const RGB16F = 0x881B;
pub const VERTEX_ATTRIB_ARRAY_INTEGER = 0x88FD;
pub const MAX_ARRAY_TEXTURE_LAYERS = 0x88FF;
pub const MIN_PROGRAM_TEXEL_OFFSET = 0x8904;
pub const MAX_PROGRAM_TEXEL_OFFSET = 0x8905;
pub const CLAMP_READ_COLOR = 0x891C;
pub const FIXED_ONLY = 0x891D;
pub const MAX_VARYING_COMPONENTS = 0x8B4B;
pub const TEXTURE_1D_ARRAY = 0x8C18;
pub const PROXY_TEXTURE_1D_ARRAY = 0x8C19;
pub const TEXTURE_2D_ARRAY = 0x8C1A;
pub const PROXY_TEXTURE_2D_ARRAY = 0x8C1B;
pub const TEXTURE_BINDING_1D_ARRAY = 0x8C1C;
pub const TEXTURE_BINDING_2D_ARRAY = 0x8C1D;
pub const R11F_G11F_B10F = 0x8C3A;
pub const UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;
pub const RGB9_E5 = 0x8C3D;
pub const UNSIGNED_INT_5_9_9_9_REV = 0x8C3E;
pub const TEXTURE_SHARED_SIZE = 0x8C3F;
pub const TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76;
pub const TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;
pub const TRANSFORM_FEEDBACK_VARYINGS = 0x8C83;
pub const TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;
pub const TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;
pub const PRIMITIVES_GENERATED = 0x8C87;
pub const TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;
pub const RASTERIZER_DISCARD = 0x8C89;
pub const MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;
pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B;
pub const INTERLEAVED_ATTRIBS = 0x8C8C;
pub const SEPARATE_ATTRIBS = 0x8C8D;
pub const TRANSFORM_FEEDBACK_BUFFER = 0x8C8E;
pub const TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F;
pub const RGBA32UI = 0x8D70;
pub const RGB32UI = 0x8D71;
pub const RGBA16UI = 0x8D76;
pub const RGB16UI = 0x8D77;
pub const RGBA8UI = 0x8D7C;
pub const RGB8UI = 0x8D7D;
pub const RGBA32I = 0x8D82;
pub const RGB32I = 0x8D83;
pub const RGBA16I = 0x8D88;
pub const RGB16I = 0x8D89;
pub const RGBA8I = 0x8D8E;
pub const RGB8I = 0x8D8F;
pub const RED_INTEGER = 0x8D94;
pub const GREEN_INTEGER = 0x8D95;
pub const BLUE_INTEGER = 0x8D96;
pub const RGB_INTEGER = 0x8D98;
pub const RGBA_INTEGER = 0x8D99;
pub const BGR_INTEGER = 0x8D9A;
pub const BGRA_INTEGER = 0x8D9B;
pub const SAMPLER_1D_ARRAY = 0x8DC0;
pub const SAMPLER_2D_ARRAY = 0x8DC1;
pub const SAMPLER_1D_ARRAY_SHADOW = 0x8DC3;
pub const SAMPLER_2D_ARRAY_SHADOW = 0x8DC4;
pub const SAMPLER_CUBE_SHADOW = 0x8DC5;
pub const UNSIGNED_INT_VEC2 = 0x8DC6;
pub const UNSIGNED_INT_VEC3 = 0x8DC7;
pub const UNSIGNED_INT_VEC4 = 0x8DC8;
pub const INT_SAMPLER_1D = 0x8DC9;
pub const INT_SAMPLER_2D = 0x8DCA;
pub const INT_SAMPLER_3D = 0x8DCB;
pub const INT_SAMPLER_CUBE = 0x8DCC;
pub const INT_SAMPLER_1D_ARRAY = 0x8DCE;
pub const INT_SAMPLER_2D_ARRAY = 0x8DCF;
pub const UNSIGNED_INT_SAMPLER_1D = 0x8DD1;
pub const UNSIGNED_INT_SAMPLER_2D = 0x8DD2;
pub const UNSIGNED_INT_SAMPLER_3D = 0x8DD3;
pub const UNSIGNED_INT_SAMPLER_CUBE = 0x8DD4;
pub const UNSIGNED_INT_SAMPLER_1D_ARRAY = 0x8DD6;
pub const UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7;
pub const QUERY_WAIT = 0x8E13;
pub const QUERY_NO_WAIT = 0x8E14;
pub const QUERY_BY_REGION_WAIT = 0x8E15;
pub const QUERY_BY_REGION_NO_WAIT = 0x8E16;
pub const BUFFER_ACCESS_FLAGS = 0x911F;
pub const BUFFER_MAP_LENGTH = 0x9120;
pub const BUFFER_MAP_OFFSET = 0x9121;
pub const DEPTH_COMPONENT32F = 0x8CAC;
pub const DEPTH32F_STENCIL8 = 0x8CAD;
pub const FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD;
pub const INVALID_FRAMEBUFFER_OPERATION = 0x0506;
pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
pub const FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
pub const FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
pub const FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
pub const FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
pub const FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
pub const FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
pub const FRAMEBUFFER_DEFAULT = 0x8218;
pub const FRAMEBUFFER_UNDEFINED = 0x8219;
pub const DEPTH_STENCIL_ATTACHMENT = 0x821A;
pub const MAX_RENDERBUFFER_SIZE = 0x84E8;
pub const DEPTH_STENCIL = 0x84F9;
pub const UNSIGNED_INT_24_8 = 0x84FA;
pub const DEPTH24_STENCIL8 = 0x88F0;
pub const TEXTURE_STENCIL_SIZE = 0x88F1;
pub const TEXTURE_RED_TYPE = 0x8C10;
pub const TEXTURE_GREEN_TYPE = 0x8C11;
pub const TEXTURE_BLUE_TYPE = 0x8C12;
pub const TEXTURE_ALPHA_TYPE = 0x8C13;
pub const TEXTURE_DEPTH_TYPE = 0x8C16;
pub const UNSIGNED_NORMALIZED = 0x8C17;
pub const FRAMEBUFFER_BINDING = 0x8CA6;
pub const DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
pub const RENDERBUFFER_BINDING = 0x8CA7;
pub const READ_FRAMEBUFFER = 0x8CA8;
pub const DRAW_FRAMEBUFFER = 0x8CA9;
pub const READ_FRAMEBUFFER_BINDING = 0x8CAA;
pub const RENDERBUFFER_SAMPLES = 0x8CAB;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
pub const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
pub const FRAMEBUFFER_COMPLETE = 0x8CD5;
pub const FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
pub const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
pub const FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDB;
pub const FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDC;
pub const FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
pub const MAX_COLOR_ATTACHMENTS = 0x8CDF;
pub const COLOR_ATTACHMENT0 = 0x8CE0;
pub const COLOR_ATTACHMENT1 = 0x8CE1;
pub const COLOR_ATTACHMENT2 = 0x8CE2;
pub const COLOR_ATTACHMENT3 = 0x8CE3;
pub const COLOR_ATTACHMENT4 = 0x8CE4;
pub const COLOR_ATTACHMENT5 = 0x8CE5;
pub const COLOR_ATTACHMENT6 = 0x8CE6;
pub const COLOR_ATTACHMENT7 = 0x8CE7;
pub const COLOR_ATTACHMENT8 = 0x8CE8;
pub const COLOR_ATTACHMENT9 = 0x8CE9;
pub const COLOR_ATTACHMENT10 = 0x8CEA;
pub const COLOR_ATTACHMENT11 = 0x8CEB;
pub const COLOR_ATTACHMENT12 = 0x8CEC;
pub const COLOR_ATTACHMENT13 = 0x8CED;
pub const COLOR_ATTACHMENT14 = 0x8CEE;
pub const COLOR_ATTACHMENT15 = 0x8CEF;
pub const COLOR_ATTACHMENT16 = 0x8CF0;
pub const COLOR_ATTACHMENT17 = 0x8CF1;
pub const COLOR_ATTACHMENT18 = 0x8CF2;
pub const COLOR_ATTACHMENT19 = 0x8CF3;
pub const COLOR_ATTACHMENT20 = 0x8CF4;
pub const COLOR_ATTACHMENT21 = 0x8CF5;
pub const COLOR_ATTACHMENT22 = 0x8CF6;
pub const COLOR_ATTACHMENT23 = 0x8CF7;
pub const COLOR_ATTACHMENT24 = 0x8CF8;
pub const COLOR_ATTACHMENT25 = 0x8CF9;
pub const COLOR_ATTACHMENT26 = 0x8CFA;
pub const COLOR_ATTACHMENT27 = 0x8CFB;
pub const COLOR_ATTACHMENT28 = 0x8CFC;
pub const COLOR_ATTACHMENT29 = 0x8CFD;
pub const COLOR_ATTACHMENT30 = 0x8CFE;
pub const COLOR_ATTACHMENT31 = 0x8CFF;
pub const DEPTH_ATTACHMENT = 0x8D00;
pub const STENCIL_ATTACHMENT = 0x8D20;
pub const FRAMEBUFFER = 0x8D40;
pub const RENDERBUFFER = 0x8D41;
pub const RENDERBUFFER_WIDTH = 0x8D42;
pub const RENDERBUFFER_HEIGHT = 0x8D43;
pub const RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;
pub const STENCIL_INDEX1 = 0x8D46;
pub const STENCIL_INDEX4 = 0x8D47;
pub const STENCIL_INDEX8 = 0x8D48;
pub const STENCIL_INDEX16 = 0x8D49;
pub const RENDERBUFFER_RED_SIZE = 0x8D50;
pub const RENDERBUFFER_GREEN_SIZE = 0x8D51;
pub const RENDERBUFFER_BLUE_SIZE = 0x8D52;
pub const RENDERBUFFER_ALPHA_SIZE = 0x8D53;
pub const RENDERBUFFER_DEPTH_SIZE = 0x8D54;
pub const RENDERBUFFER_STENCIL_SIZE = 0x8D55;
pub const FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
pub const MAX_SAMPLES = 0x8D57;
pub const LINES_ADJACENCY = 0x000A;
pub const CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002;
pub const CONTEXT_CORE_PROFILE_BIT = 0x00000001;
pub const FRAMEBUFFER_SRGB = 0x8DB9;
pub const HALF_FLOAT = 0x140B;
pub const MAP_READ_BIT = 0x0001;
pub const MAP_WRITE_BIT = 0x0002;
pub const MAP_INVALIDATE_RANGE_BIT = 0x0004;
pub const MAP_INVALIDATE_BUFFER_BIT = 0x0008;
pub const MAP_FLUSH_EXPLICIT_BIT = 0x0010;
pub const MAP_UNSYNCHRONIZED_BIT = 0x0020;
pub const COMPRESSED_RED_RGTC1 = 0x8DBB;
pub const COMPRESSED_SIGNED_RED_RGTC1 = 0x8DBC;
pub const COMPRESSED_RG_RGTC2 = 0x8DBD;
pub const COMPRESSED_SIGNED_RG_RGTC2 = 0x8DBE;
pub const RG = 0x8227;
pub const RG_INTEGER = 0x8228;
pub const R8 = 0x8229;
pub const R16 = 0x822A;
pub const RG8 = 0x822B;
pub const RG16 = 0x822C;
pub const R16F = 0x822D;
pub const R32F = 0x822E;
pub const RG16F = 0x822F;
pub const RG32F = 0x8230;
pub const R8I = 0x8231;
pub const R8UI = 0x8232;
pub const R16I = 0x8233;
pub const R16UI = 0x8234;
pub const R32I = 0x8235;
pub const R32UI = 0x8236;
pub const RG8I = 0x8237;
pub const RG8UI = 0x8238;
pub const RG16I = 0x8239;
pub const RG16UI = 0x823A;
pub const RG32I = 0x823B;
pub const RG32UI = 0x823C;
pub const VERTEX_ARRAY_BINDING = 0x85B5;
pub const TRIANGLE_STRIP_ADJACENCY = 0x000D;
pub const TRIANGLES_ADJACENCY = 0x000C;
pub const LINE_STRIP_ADJACENCY = 0x000B;
pub const SAMPLER_2D_RECT = 0x8B63;
pub const SAMPLER_2D_RECT_SHADOW = 0x8B64;
pub const SAMPLER_BUFFER = 0x8DC2;
pub const INT_SAMPLER_2D_RECT = 0x8DCD;
pub const INT_SAMPLER_BUFFER = 0x8DD0;
pub const UNSIGNED_INT_SAMPLER_2D_RECT = 0x8DD5;
pub const UNSIGNED_INT_SAMPLER_BUFFER = 0x8DD8;
pub const TEXTURE_BUFFER = 0x8C2A;
pub const MAX_TEXTURE_BUFFER_SIZE = 0x8C2B;
pub const TEXTURE_BINDING_BUFFER = 0x8C2C;
pub const TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2D;
pub const TEXTURE_RECTANGLE = 0x84F5;
pub const TEXTURE_BINDING_RECTANGLE = 0x84F6;
pub const PROXY_TEXTURE_RECTANGLE = 0x84F7;
pub const MAX_RECTANGLE_TEXTURE_SIZE = 0x84F8;
pub const R8_SNORM = 0x8F94;
pub const RG8_SNORM = 0x8F95;
pub const RGB8_SNORM = 0x8F96;
pub const RGBA8_SNORM = 0x8F97;
pub const R16_SNORM = 0x8F98;
pub const RG16_SNORM = 0x8F99;
pub const RGB16_SNORM = 0x8F9A;
pub const RGBA16_SNORM = 0x8F9B;
pub const SIGNED_NORMALIZED = 0x8F9C;
pub const PRIMITIVE_RESTART = 0x8F9D;
pub const PRIMITIVE_RESTART_INDEX = 0x8F9E;
pub const COPY_READ_BUFFER = 0x8F36;
pub const COPY_WRITE_BUFFER = 0x8F37;
pub const UNIFORM_BUFFER = 0x8A11;
pub const UNIFORM_BUFFER_BINDING = 0x8A28;
pub const UNIFORM_BUFFER_START = 0x8A29;
pub const UNIFORM_BUFFER_SIZE = 0x8A2A;
pub const MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;
pub const MAX_GEOMETRY_UNIFORM_BLOCKS = 0x8A2C;
pub const MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;
pub const MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;
pub const MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;
pub const MAX_UNIFORM_BLOCK_SIZE = 0x8A30;
pub const MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
pub const MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32;
pub const MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
pub const UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
pub const ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35;
pub const ACTIVE_UNIFORM_BLOCKS = 0x8A36;
pub const UNIFORM_TYPE = 0x8A37;
pub const UNIFORM_SIZE = 0x8A38;
pub const UNIFORM_NAME_LENGTH = 0x8A39;
pub const UNIFORM_BLOCK_INDEX = 0x8A3A;
pub const UNIFORM_OFFSET = 0x8A3B;
pub const UNIFORM_ARRAY_STRIDE = 0x8A3C;
pub const UNIFORM_MATRIX_STRIDE = 0x8A3D;
pub const UNIFORM_IS_ROW_MAJOR = 0x8A3E;
pub const UNIFORM_BLOCK_BINDING = 0x8A3F;
pub const UNIFORM_BLOCK_DATA_SIZE = 0x8A40;
pub const UNIFORM_BLOCK_NAME_LENGTH = 0x8A41;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;
pub const UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
pub const UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
pub const UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45;
pub const UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
pub const INVALID_INDEX = 0xFFFFFFFF;


pub fn cullFace(mode: GLenum) void {
    return (function_pointers.glCullFace orelse @panic("glCullFace was not bound."))(mode);
}

pub fn frontFace(mode: GLenum) void {
    return (function_pointers.glFrontFace orelse @panic("glFrontFace was not bound."))(mode);
}

pub fn hint(target: GLenum, mode: GLenum) void {
    return (function_pointers.glHint orelse @panic("glHint was not bound."))(target, mode);
}

pub fn lineWidth(width: GLfloat) void {
    return (function_pointers.glLineWidth orelse @panic("glLineWidth was not bound."))(width);
}

pub fn pointSize(size: GLfloat) void {
    return (function_pointers.glPointSize orelse @panic("glPointSize was not bound."))(size);
}

pub fn polygonMode(face: GLenum, mode: GLenum) void {
    return (function_pointers.glPolygonMode orelse @panic("glPolygonMode was not bound."))(face, mode);
}

pub fn scissor(x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glScissor orelse @panic("glScissor was not bound."))(x, y, width, height);
}

pub fn texParameterf(target: GLenum, pname: GLenum, param: GLfloat) void {
    return (function_pointers.glTexParameterf orelse @panic("glTexParameterf was not bound."))(target, pname, param);
}

pub fn texParameterfv(target: GLenum, pname: GLenum, params: [*c]const GLfloat) void {
    return (function_pointers.glTexParameterfv orelse @panic("glTexParameterfv was not bound."))(target, pname, params);
}

pub fn texParameteri(target: GLenum, pname: GLenum, param: GLint) void {
    return (function_pointers.glTexParameteri orelse @panic("glTexParameteri was not bound."))(target, pname, param);
}

pub fn texParameteriv(target: GLenum, pname: GLenum, params: [*c]const GLint) void {
    return (function_pointers.glTexParameteriv orelse @panic("glTexParameteriv was not bound."))(target, pname, params);
}

pub fn texImage1D(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexImage1D orelse @panic("glTexImage1D was not bound."))(target, level, internalformat, width, border, format, type, pixels);
}

pub fn texImage2D(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexImage2D orelse @panic("glTexImage2D was not bound."))(target, level, internalformat, width, height, border, format, type, pixels);
}

pub fn drawBuffer(buf: GLenum) void {
    return (function_pointers.glDrawBuffer orelse @panic("glDrawBuffer was not bound."))(buf);
}

pub fn clear(mask: GLbitfield) void {
    return (function_pointers.glClear orelse @panic("glClear was not bound."))(mask);
}

pub fn clearColor(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) void {
    return (function_pointers.glClearColor orelse @panic("glClearColor was not bound."))(red, green, blue, alpha);
}

pub fn clearStencil(s: GLint) void {
    return (function_pointers.glClearStencil orelse @panic("glClearStencil was not bound."))(s);
}

pub fn clearDepth(depth: GLdouble) void {
    return (function_pointers.glClearDepth orelse @panic("glClearDepth was not bound."))(depth);
}

pub fn stencilMask(mask: GLuint) void {
    return (function_pointers.glStencilMask orelse @panic("glStencilMask was not bound."))(mask);
}

pub fn colorMask(red: GLboolean, green: GLboolean, blue: GLboolean, alpha: GLboolean) void {
    return (function_pointers.glColorMask orelse @panic("glColorMask was not bound."))(red, green, blue, alpha);
}

pub fn depthMask(flag: GLboolean) void {
    return (function_pointers.glDepthMask orelse @panic("glDepthMask was not bound."))(flag);
}

pub fn disable(cap: GLenum) void {
    return (function_pointers.glDisable orelse @panic("glDisable was not bound."))(cap);
}

pub fn enable(cap: GLenum) void {
    return (function_pointers.glEnable orelse @panic("glEnable was not bound."))(cap);
}

pub fn finish() void {
    return (function_pointers.glFinish orelse @panic("glFinish was not bound."))();
}

pub fn flush() void {
    return (function_pointers.glFlush orelse @panic("glFlush was not bound."))();
}

pub fn blendFunc(sfactor: GLenum, dfactor: GLenum) void {
    return (function_pointers.glBlendFunc orelse @panic("glBlendFunc was not bound."))(sfactor, dfactor);
}

pub fn logicOp(opcode: GLenum) void {
    return (function_pointers.glLogicOp orelse @panic("glLogicOp was not bound."))(opcode);
}

pub fn stencilFunc(func: GLenum, ref: GLint, mask: GLuint) void {
    return (function_pointers.glStencilFunc orelse @panic("glStencilFunc was not bound."))(func, ref, mask);
}

pub fn stencilOp(fail: GLenum, zfail: GLenum, zpass: GLenum) void {
    return (function_pointers.glStencilOp orelse @panic("glStencilOp was not bound."))(fail, zfail, zpass);
}

pub fn depthFunc(func: GLenum) void {
    return (function_pointers.glDepthFunc orelse @panic("glDepthFunc was not bound."))(func);
}

pub fn pixelStoref(pname: GLenum, param: GLfloat) void {
    return (function_pointers.glPixelStoref orelse @panic("glPixelStoref was not bound."))(pname, param);
}

pub fn pixelStorei(pname: GLenum, param: GLint) void {
    return (function_pointers.glPixelStorei orelse @panic("glPixelStorei was not bound."))(pname, param);
}

pub fn readBuffer(src: GLenum) void {
    return (function_pointers.glReadBuffer orelse @panic("glReadBuffer was not bound."))(src);
}

pub fn readPixels(x: GLint, y: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *c_void) void {
    return (function_pointers.glReadPixels orelse @panic("glReadPixels was not bound."))(x, y, width, height, format, type, pixels);
}

pub fn getBooleanv(pname: GLenum, data: [*c]GLboolean) void {
    return (function_pointers.glGetBooleanv orelse @panic("glGetBooleanv was not bound."))(pname, data);
}

pub fn getDoublev(pname: GLenum, data: [*c]GLdouble) void {
    return (function_pointers.glGetDoublev orelse @panic("glGetDoublev was not bound."))(pname, data);
}

pub fn getError() GLenum {
    return (function_pointers.glGetError orelse @panic("glGetError was not bound."))();
}

pub fn getFloatv(pname: GLenum, data: [*c]GLfloat) void {
    return (function_pointers.glGetFloatv orelse @panic("glGetFloatv was not bound."))(pname, data);
}

pub fn getIntegerv(pname: GLenum, data: [*c]GLint) void {
    return (function_pointers.glGetIntegerv orelse @panic("glGetIntegerv was not bound."))(pname, data);
}

pub fn getString(name: GLenum) [*:0]const GLubyte {
    return (function_pointers.glGetString orelse @panic("glGetString was not bound."))(name);
}

pub fn getTexImage(target: GLenum, level: GLint, format: GLenum, type: GLenum, pixels: *c_void) void {
    return (function_pointers.glGetTexImage orelse @panic("glGetTexImage was not bound."))(target, level, format, type, pixels);
}

pub fn getTexParameterfv(target: GLenum, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetTexParameterfv orelse @panic("glGetTexParameterfv was not bound."))(target, pname, params);
}

pub fn getTexParameteriv(target: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTexParameteriv orelse @panic("glGetTexParameteriv was not bound."))(target, pname, params);
}

pub fn getTexLevelParameterfv(target: GLenum, level: GLint, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetTexLevelParameterfv orelse @panic("glGetTexLevelParameterfv was not bound."))(target, level, pname, params);
}

pub fn getTexLevelParameteriv(target: GLenum, level: GLint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTexLevelParameteriv orelse @panic("glGetTexLevelParameteriv was not bound."))(target, level, pname, params);
}

pub fn isEnabled(cap: GLenum) GLboolean {
    return (function_pointers.glIsEnabled orelse @panic("glIsEnabled was not bound."))(cap);
}

pub fn depthRange(n: GLdouble, f: GLdouble) void {
    return (function_pointers.glDepthRange orelse @panic("glDepthRange was not bound."))(n, f);
}

pub fn viewport(x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glViewport orelse @panic("glViewport was not bound."))(x, y, width, height);
}

pub fn drawArrays(mode: GLenum, first: GLint, count: GLsizei) void {
    return (function_pointers.glDrawArrays orelse @panic("glDrawArrays was not bound."))(mode, first, count);
}

pub fn drawElements(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void) void {
    return (function_pointers.glDrawElements orelse @panic("glDrawElements was not bound."))(mode, count, type, indices);
}

pub fn polygonOffset(factor: GLfloat, units: GLfloat) void {
    return (function_pointers.glPolygonOffset orelse @panic("glPolygonOffset was not bound."))(factor, units);
}

pub fn copyTexImage1D(target: GLenum, level: GLint, internalformat: GLenum, x: GLint, y: GLint, width: GLsizei, border: GLint) void {
    return (function_pointers.glCopyTexImage1D orelse @panic("glCopyTexImage1D was not bound."))(target, level, internalformat, x, y, width, border);
}

pub fn copyTexImage2D(target: GLenum, level: GLint, internalformat: GLenum, x: GLint, y: GLint, width: GLsizei, height: GLsizei, border: GLint) void {
    return (function_pointers.glCopyTexImage2D orelse @panic("glCopyTexImage2D was not bound."))(target, level, internalformat, x, y, width, height, border);
}

pub fn copyTexSubImage1D(target: GLenum, level: GLint, xoffset: GLint, x: GLint, y: GLint, width: GLsizei) void {
    return (function_pointers.glCopyTexSubImage1D orelse @panic("glCopyTexSubImage1D was not bound."))(target, level, xoffset, x, y, width);
}

pub fn copyTexSubImage2D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glCopyTexSubImage2D orelse @panic("glCopyTexSubImage2D was not bound."))(target, level, xoffset, yoffset, x, y, width, height);
}

pub fn texSubImage1D(target: GLenum, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexSubImage1D orelse @panic("glTexSubImage1D was not bound."))(target, level, xoffset, width, format, type, pixels);
}

pub fn texSubImage2D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexSubImage2D orelse @panic("glTexSubImage2D was not bound."))(target, level, xoffset, yoffset, width, height, format, type, pixels);
}

pub fn bindTexture(target: GLenum, texture: GLuint) void {
    return (function_pointers.glBindTexture orelse @panic("glBindTexture was not bound."))(target, texture);
}

pub fn deleteTextures(n: GLsizei, textures: [*c]const GLuint) void {
    return (function_pointers.glDeleteTextures orelse @panic("glDeleteTextures was not bound."))(n, textures);
}

pub fn genTextures(n: GLsizei, textures: [*c]GLuint) void {
    return (function_pointers.glGenTextures orelse @panic("glGenTextures was not bound."))(n, textures);
}

pub fn isTexture(texture: GLuint) GLboolean {
    return (function_pointers.glIsTexture orelse @panic("glIsTexture was not bound."))(texture);
}

pub fn drawRangeElements(mode: GLenum, start: GLuint, end: GLuint, count: GLsizei, type: GLenum, indices: *const c_void) void {
    return (function_pointers.glDrawRangeElements orelse @panic("glDrawRangeElements was not bound."))(mode, start, end, count, type, indices);
}

pub fn texImage3D(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexImage3D orelse @panic("glTexImage3D was not bound."))(target, level, internalformat, width, height, depth, border, format, type, pixels);
}

pub fn texSubImage3D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTexSubImage3D orelse @panic("glTexSubImage3D was not bound."))(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
}

pub fn copyTexSubImage3D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glCopyTexSubImage3D orelse @panic("glCopyTexSubImage3D was not bound."))(target, level, xoffset, yoffset, zoffset, x, y, width, height);
}

pub fn secondaryColorP3uiv(type: GLenum, color: [*c]const GLuint) void {
    return (function_pointers.glSecondaryColorP3uiv orelse @panic("glSecondaryColorP3uiv was not bound."))(type, color);
}

pub fn secondaryColorP3ui(type: GLenum, color: GLuint) void {
    return (function_pointers.glSecondaryColorP3ui orelse @panic("glSecondaryColorP3ui was not bound."))(type, color);
}

pub fn colorP4uiv(type: GLenum, color: [*c]const GLuint) void {
    return (function_pointers.glColorP4uiv orelse @panic("glColorP4uiv was not bound."))(type, color);
}

pub fn colorP4ui(type: GLenum, color: GLuint) void {
    return (function_pointers.glColorP4ui orelse @panic("glColorP4ui was not bound."))(type, color);
}

pub fn colorP3uiv(type: GLenum, color: [*c]const GLuint) void {
    return (function_pointers.glColorP3uiv orelse @panic("glColorP3uiv was not bound."))(type, color);
}

pub fn colorP3ui(type: GLenum, color: GLuint) void {
    return (function_pointers.glColorP3ui orelse @panic("glColorP3ui was not bound."))(type, color);
}

pub fn normalP3uiv(type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glNormalP3uiv orelse @panic("glNormalP3uiv was not bound."))(type, coords);
}

pub fn normalP3ui(type: GLenum, coords: GLuint) void {
    return (function_pointers.glNormalP3ui orelse @panic("glNormalP3ui was not bound."))(type, coords);
}

pub fn multiTexCoordP4uiv(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glMultiTexCoordP4uiv orelse @panic("glMultiTexCoordP4uiv was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP4ui(texture: GLenum, type: GLenum, coords: GLuint) void {
    return (function_pointers.glMultiTexCoordP4ui orelse @panic("glMultiTexCoordP4ui was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP3uiv(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glMultiTexCoordP3uiv orelse @panic("glMultiTexCoordP3uiv was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP3ui(texture: GLenum, type: GLenum, coords: GLuint) void {
    return (function_pointers.glMultiTexCoordP3ui orelse @panic("glMultiTexCoordP3ui was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP2uiv(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glMultiTexCoordP2uiv orelse @panic("glMultiTexCoordP2uiv was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP2ui(texture: GLenum, type: GLenum, coords: GLuint) void {
    return (function_pointers.glMultiTexCoordP2ui orelse @panic("glMultiTexCoordP2ui was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP1uiv(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glMultiTexCoordP1uiv orelse @panic("glMultiTexCoordP1uiv was not bound."))(texture, type, coords);
}

pub fn multiTexCoordP1ui(texture: GLenum, type: GLenum, coords: GLuint) void {
    return (function_pointers.glMultiTexCoordP1ui orelse @panic("glMultiTexCoordP1ui was not bound."))(texture, type, coords);
}

pub fn texCoordP4uiv(type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glTexCoordP4uiv orelse @panic("glTexCoordP4uiv was not bound."))(type, coords);
}

pub fn texCoordP4ui(type: GLenum, coords: GLuint) void {
    return (function_pointers.glTexCoordP4ui orelse @panic("glTexCoordP4ui was not bound."))(type, coords);
}

pub fn texCoordP3uiv(type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glTexCoordP3uiv orelse @panic("glTexCoordP3uiv was not bound."))(type, coords);
}

pub fn texCoordP3ui(type: GLenum, coords: GLuint) void {
    return (function_pointers.glTexCoordP3ui orelse @panic("glTexCoordP3ui was not bound."))(type, coords);
}

pub fn activeTexture(texture: GLenum) void {
    return (function_pointers.glActiveTexture orelse @panic("glActiveTexture was not bound."))(texture);
}

pub fn sampleCoverage(value: GLfloat, invert: GLboolean) void {
    return (function_pointers.glSampleCoverage orelse @panic("glSampleCoverage was not bound."))(value, invert);
}

pub fn compressedTexImage3D(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexImage3D orelse @panic("glCompressedTexImage3D was not bound."))(target, level, internalformat, width, height, depth, border, imageSize, data);
}

pub fn compressedTexImage2D(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, height: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexImage2D orelse @panic("glCompressedTexImage2D was not bound."))(target, level, internalformat, width, height, border, imageSize, data);
}

pub fn compressedTexImage1D(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexImage1D orelse @panic("glCompressedTexImage1D was not bound."))(target, level, internalformat, width, border, imageSize, data);
}

pub fn compressedTexSubImage3D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexSubImage3D orelse @panic("glCompressedTexSubImage3D was not bound."))(target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
}

pub fn compressedTexSubImage2D(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexSubImage2D orelse @panic("glCompressedTexSubImage2D was not bound."))(target, level, xoffset, yoffset, width, height, format, imageSize, data);
}

pub fn compressedTexSubImage1D(target: GLenum, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTexSubImage1D orelse @panic("glCompressedTexSubImage1D was not bound."))(target, level, xoffset, width, format, imageSize, data);
}

pub fn getCompressedTexImage(target: GLenum, level: GLint, img: *c_void) void {
    return (function_pointers.glGetCompressedTexImage orelse @panic("glGetCompressedTexImage was not bound."))(target, level, img);
}

pub fn texCoordP2uiv(type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glTexCoordP2uiv orelse @panic("glTexCoordP2uiv was not bound."))(type, coords);
}

pub fn texCoordP2ui(type: GLenum, coords: GLuint) void {
    return (function_pointers.glTexCoordP2ui orelse @panic("glTexCoordP2ui was not bound."))(type, coords);
}

pub fn texCoordP1uiv(type: GLenum, coords: [*c]const GLuint) void {
    return (function_pointers.glTexCoordP1uiv orelse @panic("glTexCoordP1uiv was not bound."))(type, coords);
}

pub fn texCoordP1ui(type: GLenum, coords: GLuint) void {
    return (function_pointers.glTexCoordP1ui orelse @panic("glTexCoordP1ui was not bound."))(type, coords);
}

pub fn vertexP4uiv(type: GLenum, value: [*c]const GLuint) void {
    return (function_pointers.glVertexP4uiv orelse @panic("glVertexP4uiv was not bound."))(type, value);
}

pub fn vertexP4ui(type: GLenum, value: GLuint) void {
    return (function_pointers.glVertexP4ui orelse @panic("glVertexP4ui was not bound."))(type, value);
}

pub fn vertexP3uiv(type: GLenum, value: [*c]const GLuint) void {
    return (function_pointers.glVertexP3uiv orelse @panic("glVertexP3uiv was not bound."))(type, value);
}

pub fn vertexP3ui(type: GLenum, value: GLuint) void {
    return (function_pointers.glVertexP3ui orelse @panic("glVertexP3ui was not bound."))(type, value);
}

pub fn vertexP2uiv(type: GLenum, value: [*c]const GLuint) void {
    return (function_pointers.glVertexP2uiv orelse @panic("glVertexP2uiv was not bound."))(type, value);
}

pub fn vertexP2ui(type: GLenum, value: GLuint) void {
    return (function_pointers.glVertexP2ui orelse @panic("glVertexP2ui was not bound."))(type, value);
}

pub fn vertexAttribP4uiv(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP4uiv orelse @panic("glVertexAttribP4uiv was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP4ui(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void {
    return (function_pointers.glVertexAttribP4ui orelse @panic("glVertexAttribP4ui was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP3uiv(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP3uiv orelse @panic("glVertexAttribP3uiv was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP3ui(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void {
    return (function_pointers.glVertexAttribP3ui orelse @panic("glVertexAttribP3ui was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP2uiv(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP2uiv orelse @panic("glVertexAttribP2uiv was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP2ui(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void {
    return (function_pointers.glVertexAttribP2ui orelse @panic("glVertexAttribP2ui was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP1uiv(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribP1uiv orelse @panic("glVertexAttribP1uiv was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribP1ui(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void {
    return (function_pointers.glVertexAttribP1ui orelse @panic("glVertexAttribP1ui was not bound."))(index, type, normalized, value);
}

pub fn vertexAttribDivisor(index: GLuint, divisor: GLuint) void {
    return (function_pointers.glVertexAttribDivisor orelse @panic("glVertexAttribDivisor was not bound."))(index, divisor);
}

pub fn getQueryObjectui64v(id: GLuint, pname: GLenum, params: [*c]GLuint64) void {
    return (function_pointers.glGetQueryObjectui64v orelse @panic("glGetQueryObjectui64v was not bound."))(id, pname, params);
}

pub fn getQueryObjecti64v(id: GLuint, pname: GLenum, params: [*c]GLint64) void {
    return (function_pointers.glGetQueryObjecti64v orelse @panic("glGetQueryObjecti64v was not bound."))(id, pname, params);
}

pub fn queryCounter(id: GLuint, target: GLenum) void {
    return (function_pointers.glQueryCounter orelse @panic("glQueryCounter was not bound."))(id, target);
}

pub fn getSamplerParameterIuiv(sampler: GLuint, pname: GLenum, params: [*c]GLuint) void {
    return (function_pointers.glGetSamplerParameterIuiv orelse @panic("glGetSamplerParameterIuiv was not bound."))(sampler, pname, params);
}

pub fn getSamplerParameterfv(sampler: GLuint, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetSamplerParameterfv orelse @panic("glGetSamplerParameterfv was not bound."))(sampler, pname, params);
}

pub fn getSamplerParameterIiv(sampler: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetSamplerParameterIiv orelse @panic("glGetSamplerParameterIiv was not bound."))(sampler, pname, params);
}

pub fn getSamplerParameteriv(sampler: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetSamplerParameteriv orelse @panic("glGetSamplerParameteriv was not bound."))(sampler, pname, params);
}

pub fn samplerParameterIuiv(sampler: GLuint, pname: GLenum, param: [*c]const GLuint) void {
    return (function_pointers.glSamplerParameterIuiv orelse @panic("glSamplerParameterIuiv was not bound."))(sampler, pname, param);
}

pub fn samplerParameterIiv(sampler: GLuint, pname: GLenum, param: [*c]const GLint) void {
    return (function_pointers.glSamplerParameterIiv orelse @panic("glSamplerParameterIiv was not bound."))(sampler, pname, param);
}

pub fn samplerParameterfv(sampler: GLuint, pname: GLenum, param: [*c]const GLfloat) void {
    return (function_pointers.glSamplerParameterfv orelse @panic("glSamplerParameterfv was not bound."))(sampler, pname, param);
}

pub fn samplerParameterf(sampler: GLuint, pname: GLenum, param: GLfloat) void {
    return (function_pointers.glSamplerParameterf orelse @panic("glSamplerParameterf was not bound."))(sampler, pname, param);
}

pub fn samplerParameteriv(sampler: GLuint, pname: GLenum, param: [*c]const GLint) void {
    return (function_pointers.glSamplerParameteriv orelse @panic("glSamplerParameteriv was not bound."))(sampler, pname, param);
}

pub fn samplerParameteri(sampler: GLuint, pname: GLenum, param: GLint) void {
    return (function_pointers.glSamplerParameteri orelse @panic("glSamplerParameteri was not bound."))(sampler, pname, param);
}

pub fn bindSampler(unit: GLuint, sampler: GLuint) void {
    return (function_pointers.glBindSampler orelse @panic("glBindSampler was not bound."))(unit, sampler);
}

pub fn isSampler(sampler: GLuint) GLboolean {
    return (function_pointers.glIsSampler orelse @panic("glIsSampler was not bound."))(sampler);
}

pub fn deleteSamplers(count: GLsizei, samplers: [*c]const GLuint) void {
    return (function_pointers.glDeleteSamplers orelse @panic("glDeleteSamplers was not bound."))(count, samplers);
}

pub fn genSamplers(count: GLsizei, samplers: [*c]GLuint) void {
    return (function_pointers.glGenSamplers orelse @panic("glGenSamplers was not bound."))(count, samplers);
}

pub fn getFragDataIndex(program: GLuint, name: [*c]const GLchar) GLint {
    return (function_pointers.glGetFragDataIndex orelse @panic("glGetFragDataIndex was not bound."))(program, name);
}

pub fn bindFragDataLocationIndexed(program: GLuint, colorNumber: GLuint, index: GLuint, name: [*c]const GLchar) void {
    return (function_pointers.glBindFragDataLocationIndexed orelse @panic("glBindFragDataLocationIndexed was not bound."))(program, colorNumber, index, name);
}

pub fn sampleMaski(maskNumber: GLuint, mask: GLbitfield) void {
    return (function_pointers.glSampleMaski orelse @panic("glSampleMaski was not bound."))(maskNumber, mask);
}

pub fn getMultisamplefv(pname: GLenum, index: GLuint, val: [*c]GLfloat) void {
    return (function_pointers.glGetMultisamplefv orelse @panic("glGetMultisamplefv was not bound."))(pname, index, val);
}

pub fn texImage3DMultisample(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTexImage3DMultisample orelse @panic("glTexImage3DMultisample was not bound."))(target, samples, internalformat, width, height, depth, fixedsamplelocations);
}

pub fn texImage2DMultisample(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTexImage2DMultisample orelse @panic("glTexImage2DMultisample was not bound."))(target, samples, internalformat, width, height, fixedsamplelocations);
}

pub fn framebufferTexture(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint) void {
    return (function_pointers.glFramebufferTexture orelse @panic("glFramebufferTexture was not bound."))(target, attachment, texture, level);
}

pub fn getBufferParameteri64v(target: GLenum, pname: GLenum, params: [*c]GLint64) void {
    return (function_pointers.glGetBufferParameteri64v orelse @panic("glGetBufferParameteri64v was not bound."))(target, pname, params);
}

pub fn blendFuncSeparate(sfactorRGB: GLenum, dfactorRGB: GLenum, sfactorAlpha: GLenum, dfactorAlpha: GLenum) void {
    return (function_pointers.glBlendFuncSeparate orelse @panic("glBlendFuncSeparate was not bound."))(sfactorRGB, dfactorRGB, sfactorAlpha, dfactorAlpha);
}

pub fn multiDrawArrays(mode: GLenum, first: [*c]const GLint, count: [*c]const GLsizei, drawcount: GLsizei) void {
    return (function_pointers.glMultiDrawArrays orelse @panic("glMultiDrawArrays was not bound."))(mode, first, count, drawcount);
}

pub fn multiDrawElements(mode: GLenum, count: [*c]const GLsizei, type: GLenum, indices: [*c]const *const c_void, drawcount: GLsizei) void {
    return (function_pointers.glMultiDrawElements orelse @panic("glMultiDrawElements was not bound."))(mode, count, type, indices, drawcount);
}

pub fn pointParameterf(pname: GLenum, param: GLfloat) void {
    return (function_pointers.glPointParameterf orelse @panic("glPointParameterf was not bound."))(pname, param);
}

pub fn pointParameterfv(pname: GLenum, params: [*c]const GLfloat) void {
    return (function_pointers.glPointParameterfv orelse @panic("glPointParameterfv was not bound."))(pname, params);
}

pub fn pointParameteri(pname: GLenum, param: GLint) void {
    return (function_pointers.glPointParameteri orelse @panic("glPointParameteri was not bound."))(pname, param);
}

pub fn pointParameteriv(pname: GLenum, params: [*c]const GLint) void {
    return (function_pointers.glPointParameteriv orelse @panic("glPointParameteriv was not bound."))(pname, params);
}

pub fn getInteger64i_v(target: GLenum, index: GLuint, data: [*c]GLint64) void {
    return (function_pointers.glGetInteger64i_v orelse @panic("glGetInteger64i_v was not bound."))(target, index, data);
}

pub fn getSynciv(sync: GLsync, pname: GLenum, count: GLsizei, length: [*c]GLsizei, values: [*c]GLint) void {
    return (function_pointers.glGetSynciv orelse @panic("glGetSynciv was not bound."))(sync, pname, count, length, values);
}

pub fn getInteger64v(pname: GLenum, data: [*c]GLint64) void {
    return (function_pointers.glGetInteger64v orelse @panic("glGetInteger64v was not bound."))(pname, data);
}

pub fn waitSync(sync: GLsync, flags: GLbitfield, timeout: GLuint64) void {
    return (function_pointers.glWaitSync orelse @panic("glWaitSync was not bound."))(sync, flags, timeout);
}

pub fn clientWaitSync(sync: GLsync, flags: GLbitfield, timeout: GLuint64) GLenum {
    return (function_pointers.glClientWaitSync orelse @panic("glClientWaitSync was not bound."))(sync, flags, timeout);
}

pub fn deleteSync(sync: GLsync) void {
    return (function_pointers.glDeleteSync orelse @panic("glDeleteSync was not bound."))(sync);
}

pub fn isSync(sync: GLsync) GLboolean {
    return (function_pointers.glIsSync orelse @panic("glIsSync was not bound."))(sync);
}

pub fn fenceSync(condition: GLenum, flags: GLbitfield) GLsync {
    return (function_pointers.glFenceSync orelse @panic("glFenceSync was not bound."))(condition, flags);
}

pub fn blendColor(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) void {
    return (function_pointers.glBlendColor orelse @panic("glBlendColor was not bound."))(red, green, blue, alpha);
}

pub fn blendEquation(mode: GLenum) void {
    return (function_pointers.glBlendEquation orelse @panic("glBlendEquation was not bound."))(mode);
}

pub fn provokingVertex(mode: GLenum) void {
    return (function_pointers.glProvokingVertex orelse @panic("glProvokingVertex was not bound."))(mode);
}

pub fn multiDrawElementsBaseVertex(mode: GLenum, count: [*c]const GLsizei, type: GLenum, indices: [*c]const *const c_void, drawcount: GLsizei, basevertex: [*c]const GLint) void {
    return (function_pointers.glMultiDrawElementsBaseVertex orelse @panic("glMultiDrawElementsBaseVertex was not bound."))(mode, count, type, indices, drawcount, basevertex);
}

pub fn drawElementsInstancedBaseVertex(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, instancecount: GLsizei, basevertex: GLint) void {
    return (function_pointers.glDrawElementsInstancedBaseVertex orelse @panic("glDrawElementsInstancedBaseVertex was not bound."))(mode, count, type, indices, instancecount, basevertex);
}

pub fn drawRangeElementsBaseVertex(mode: GLenum, start: GLuint, end: GLuint, count: GLsizei, type: GLenum, indices: *const c_void, basevertex: GLint) void {
    return (function_pointers.glDrawRangeElementsBaseVertex orelse @panic("glDrawRangeElementsBaseVertex was not bound."))(mode, start, end, count, type, indices, basevertex);
}

pub fn drawElementsBaseVertex(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, basevertex: GLint) void {
    return (function_pointers.glDrawElementsBaseVertex orelse @panic("glDrawElementsBaseVertex was not bound."))(mode, count, type, indices, basevertex);
}

pub fn genQueries(n: GLsizei, ids: [*c]GLuint) void {
    return (function_pointers.glGenQueries orelse @panic("glGenQueries was not bound."))(n, ids);
}

pub fn deleteQueries(n: GLsizei, ids: [*c]const GLuint) void {
    return (function_pointers.glDeleteQueries orelse @panic("glDeleteQueries was not bound."))(n, ids);
}

pub fn isQuery(id: GLuint) GLboolean {
    return (function_pointers.glIsQuery orelse @panic("glIsQuery was not bound."))(id);
}

pub fn beginQuery(target: GLenum, id: GLuint) void {
    return (function_pointers.glBeginQuery orelse @panic("glBeginQuery was not bound."))(target, id);
}

pub fn endQuery(target: GLenum) void {
    return (function_pointers.glEndQuery orelse @panic("glEndQuery was not bound."))(target);
}

pub fn getQueryiv(target: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetQueryiv orelse @panic("glGetQueryiv was not bound."))(target, pname, params);
}

pub fn getQueryObjectiv(id: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetQueryObjectiv orelse @panic("glGetQueryObjectiv was not bound."))(id, pname, params);
}

pub fn getQueryObjectuiv(id: GLuint, pname: GLenum, params: [*c]GLuint) void {
    return (function_pointers.glGetQueryObjectuiv orelse @panic("glGetQueryObjectuiv was not bound."))(id, pname, params);
}

pub fn bindBuffer(target: GLenum, buffer: GLuint) void {
    return (function_pointers.glBindBuffer orelse @panic("glBindBuffer was not bound."))(target, buffer);
}

pub fn deleteBuffers(n: GLsizei, buffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteBuffers orelse @panic("glDeleteBuffers was not bound."))(n, buffers);
}

pub fn genBuffers(n: GLsizei, buffers: [*c]GLuint) void {
    return (function_pointers.glGenBuffers orelse @panic("glGenBuffers was not bound."))(n, buffers);
}

pub fn isBuffer(buffer: GLuint) GLboolean {
    return (function_pointers.glIsBuffer orelse @panic("glIsBuffer was not bound."))(buffer);
}

pub fn bufferData(target: GLenum, size: GLsizeiptr, data: *const c_void, usage: GLenum) void {
    return (function_pointers.glBufferData orelse @panic("glBufferData was not bound."))(target, size, data, usage);
}

pub fn bufferSubData(target: GLenum, offset: GLintptr, size: GLsizeiptr, data: *const c_void) void {
    return (function_pointers.glBufferSubData orelse @panic("glBufferSubData was not bound."))(target, offset, size, data);
}

pub fn getBufferSubData(target: GLenum, offset: GLintptr, size: GLsizeiptr, data: *c_void) void {
    return (function_pointers.glGetBufferSubData orelse @panic("glGetBufferSubData was not bound."))(target, offset, size, data);
}

pub fn mapBuffer(target: GLenum, access: GLenum) *c_void {
    return (function_pointers.glMapBuffer orelse @panic("glMapBuffer was not bound."))(target, access);
}

pub fn unmapBuffer(target: GLenum) GLboolean {
    return (function_pointers.glUnmapBuffer orelse @panic("glUnmapBuffer was not bound."))(target);
}

pub fn getBufferParameteriv(target: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetBufferParameteriv orelse @panic("glGetBufferParameteriv was not bound."))(target, pname, params);
}

pub fn getBufferPointerv(target: GLenum, pname: GLenum, params: **c_void) void {
    return (function_pointers.glGetBufferPointerv orelse @panic("glGetBufferPointerv was not bound."))(target, pname, params);
}

pub fn blendEquationSeparate(modeRGB: GLenum, modeAlpha: GLenum) void {
    return (function_pointers.glBlendEquationSeparate orelse @panic("glBlendEquationSeparate was not bound."))(modeRGB, modeAlpha);
}

pub fn drawBuffers(n: GLsizei, bufs: [*c]const GLenum) void {
    return (function_pointers.glDrawBuffers orelse @panic("glDrawBuffers was not bound."))(n, bufs);
}

pub fn stencilOpSeparate(face: GLenum, sfail: GLenum, dpfail: GLenum, dppass: GLenum) void {
    return (function_pointers.glStencilOpSeparate orelse @panic("glStencilOpSeparate was not bound."))(face, sfail, dpfail, dppass);
}

pub fn stencilFuncSeparate(face: GLenum, func: GLenum, ref: GLint, mask: GLuint) void {
    return (function_pointers.glStencilFuncSeparate orelse @panic("glStencilFuncSeparate was not bound."))(face, func, ref, mask);
}

pub fn stencilMaskSeparate(face: GLenum, mask: GLuint) void {
    return (function_pointers.glStencilMaskSeparate orelse @panic("glStencilMaskSeparate was not bound."))(face, mask);
}

pub fn attachShader(program: GLuint, shader: GLuint) void {
    return (function_pointers.glAttachShader orelse @panic("glAttachShader was not bound."))(program, shader);
}

pub fn bindAttribLocation(program: GLuint, index: GLuint, name: [*c]const GLchar) void {
    return (function_pointers.glBindAttribLocation orelse @panic("glBindAttribLocation was not bound."))(program, index, name);
}

pub fn compileShader(shader: GLuint) void {
    return (function_pointers.glCompileShader orelse @panic("glCompileShader was not bound."))(shader);
}

pub fn createProgram() GLuint {
    return (function_pointers.glCreateProgram orelse @panic("glCreateProgram was not bound."))();
}

pub fn createShader(type: GLenum) GLuint {
    return (function_pointers.glCreateShader orelse @panic("glCreateShader was not bound."))(type);
}

pub fn deleteProgram(program: GLuint) void {
    return (function_pointers.glDeleteProgram orelse @panic("glDeleteProgram was not bound."))(program);
}

pub fn deleteShader(shader: GLuint) void {
    return (function_pointers.glDeleteShader orelse @panic("glDeleteShader was not bound."))(shader);
}

pub fn detachShader(program: GLuint, shader: GLuint) void {
    return (function_pointers.glDetachShader orelse @panic("glDetachShader was not bound."))(program, shader);
}

pub fn disableVertexAttribArray(index: GLuint) void {
    return (function_pointers.glDisableVertexAttribArray orelse @panic("glDisableVertexAttribArray was not bound."))(index);
}

pub fn enableVertexAttribArray(index: GLuint) void {
    return (function_pointers.glEnableVertexAttribArray orelse @panic("glEnableVertexAttribArray was not bound."))(index);
}

pub fn getActiveAttrib(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLint, type: [*c]GLenum, name: [*c]GLchar) void {
    return (function_pointers.glGetActiveAttrib orelse @panic("glGetActiveAttrib was not bound."))(program, index, bufSize, length, size, type, name);
}

pub fn getActiveUniform(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLint, type: [*c]GLenum, name: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniform orelse @panic("glGetActiveUniform was not bound."))(program, index, bufSize, length, size, type, name);
}

pub fn getAttachedShaders(program: GLuint, maxCount: GLsizei, count: [*c]GLsizei, shaders: [*c]GLuint) void {
    return (function_pointers.glGetAttachedShaders orelse @panic("glGetAttachedShaders was not bound."))(program, maxCount, count, shaders);
}

pub fn getAttribLocation(program: GLuint, name: [*c]const GLchar) GLint {
    return (function_pointers.glGetAttribLocation orelse @panic("glGetAttribLocation was not bound."))(program, name);
}

pub fn getProgramiv(program: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetProgramiv orelse @panic("glGetProgramiv was not bound."))(program, pname, params);
}

pub fn getProgramInfoLog(program: GLuint, bufSize: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) void {
    return (function_pointers.glGetProgramInfoLog orelse @panic("glGetProgramInfoLog was not bound."))(program, bufSize, length, infoLog);
}

pub fn getShaderiv(shader: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetShaderiv orelse @panic("glGetShaderiv was not bound."))(shader, pname, params);
}

pub fn getShaderInfoLog(shader: GLuint, bufSize: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) void {
    return (function_pointers.glGetShaderInfoLog orelse @panic("glGetShaderInfoLog was not bound."))(shader, bufSize, length, infoLog);
}

pub fn getShaderSource(shader: GLuint, bufSize: GLsizei, length: [*c]GLsizei, source: [*c]GLchar) void {
    return (function_pointers.glGetShaderSource orelse @panic("glGetShaderSource was not bound."))(shader, bufSize, length, source);
}

pub fn getUniformLocation(program: GLuint, name: [*c]const GLchar) GLint {
    return (function_pointers.glGetUniformLocation orelse @panic("glGetUniformLocation was not bound."))(program, name);
}

pub fn getUniformfv(program: GLuint, location: GLint, params: [*c]GLfloat) void {
    return (function_pointers.glGetUniformfv orelse @panic("glGetUniformfv was not bound."))(program, location, params);
}

pub fn getUniformiv(program: GLuint, location: GLint, params: [*c]GLint) void {
    return (function_pointers.glGetUniformiv orelse @panic("glGetUniformiv was not bound."))(program, location, params);
}

pub fn getVertexAttribdv(index: GLuint, pname: GLenum, params: [*c]GLdouble) void {
    return (function_pointers.glGetVertexAttribdv orelse @panic("glGetVertexAttribdv was not bound."))(index, pname, params);
}

pub fn getVertexAttribfv(index: GLuint, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetVertexAttribfv orelse @panic("glGetVertexAttribfv was not bound."))(index, pname, params);
}

pub fn getVertexAttribiv(index: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetVertexAttribiv orelse @panic("glGetVertexAttribiv was not bound."))(index, pname, params);
}

pub fn getVertexAttribPointerv(index: GLuint, pname: GLenum, pointer: **c_void) void {
    return (function_pointers.glGetVertexAttribPointerv orelse @panic("glGetVertexAttribPointerv was not bound."))(index, pname, pointer);
}

pub fn isProgram(program: GLuint) GLboolean {
    return (function_pointers.glIsProgram orelse @panic("glIsProgram was not bound."))(program);
}

pub fn isShader(shader: GLuint) GLboolean {
    return (function_pointers.glIsShader orelse @panic("glIsShader was not bound."))(shader);
}

pub fn linkProgram(program: GLuint) void {
    return (function_pointers.glLinkProgram orelse @panic("glLinkProgram was not bound."))(program);
}

pub fn shaderSource(shader: GLuint, count: GLsizei, string: [*c]const [*c]const GLchar, length: [*c]const GLint) void {
    return (function_pointers.glShaderSource orelse @panic("glShaderSource was not bound."))(shader, count, string, length);
}

pub fn useProgram(program: GLuint) void {
    return (function_pointers.glUseProgram orelse @panic("glUseProgram was not bound."))(program);
}

pub fn uniform1f(location: GLint, v0: GLfloat) void {
    return (function_pointers.glUniform1f orelse @panic("glUniform1f was not bound."))(location, v0);
}

pub fn uniform2f(location: GLint, v0: GLfloat, v1: GLfloat) void {
    return (function_pointers.glUniform2f orelse @panic("glUniform2f was not bound."))(location, v0, v1);
}

pub fn uniform3f(location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat) void {
    return (function_pointers.glUniform3f orelse @panic("glUniform3f was not bound."))(location, v0, v1, v2);
}

pub fn uniform4f(location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat, v3: GLfloat) void {
    return (function_pointers.glUniform4f orelse @panic("glUniform4f was not bound."))(location, v0, v1, v2, v3);
}

pub fn uniform1i(location: GLint, v0: GLint) void {
    return (function_pointers.glUniform1i orelse @panic("glUniform1i was not bound."))(location, v0);
}

pub fn uniform2i(location: GLint, v0: GLint, v1: GLint) void {
    return (function_pointers.glUniform2i orelse @panic("glUniform2i was not bound."))(location, v0, v1);
}

pub fn uniform3i(location: GLint, v0: GLint, v1: GLint, v2: GLint) void {
    return (function_pointers.glUniform3i orelse @panic("glUniform3i was not bound."))(location, v0, v1, v2);
}

pub fn uniform4i(location: GLint, v0: GLint, v1: GLint, v2: GLint, v3: GLint) void {
    return (function_pointers.glUniform4i orelse @panic("glUniform4i was not bound."))(location, v0, v1, v2, v3);
}

pub fn uniform1fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    return (function_pointers.glUniform1fv orelse @panic("glUniform1fv was not bound."))(location, count, value);
}

pub fn uniform2fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    return (function_pointers.glUniform2fv orelse @panic("glUniform2fv was not bound."))(location, count, value);
}

pub fn uniform3fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    return (function_pointers.glUniform3fv orelse @panic("glUniform3fv was not bound."))(location, count, value);
}

pub fn uniform4fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    return (function_pointers.glUniform4fv orelse @panic("glUniform4fv was not bound."))(location, count, value);
}

pub fn uniform1iv(location: GLint, count: GLsizei, value: [*c]const GLint) void {
    return (function_pointers.glUniform1iv orelse @panic("glUniform1iv was not bound."))(location, count, value);
}

pub fn uniform2iv(location: GLint, count: GLsizei, value: [*c]const GLint) void {
    return (function_pointers.glUniform2iv orelse @panic("glUniform2iv was not bound."))(location, count, value);
}

pub fn uniform3iv(location: GLint, count: GLsizei, value: [*c]const GLint) void {
    return (function_pointers.glUniform3iv orelse @panic("glUniform3iv was not bound."))(location, count, value);
}

pub fn uniform4iv(location: GLint, count: GLsizei, value: [*c]const GLint) void {
    return (function_pointers.glUniform4iv orelse @panic("glUniform4iv was not bound."))(location, count, value);
}

pub fn uniformMatrix2fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2fv orelse @panic("glUniformMatrix2fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix3fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3fv orelse @panic("glUniformMatrix3fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix4fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4fv orelse @panic("glUniformMatrix4fv was not bound."))(location, count, transpose, value);
}

pub fn validateProgram(program: GLuint) void {
    return (function_pointers.glValidateProgram orelse @panic("glValidateProgram was not bound."))(program);
}

pub fn vertexAttrib1d(index: GLuint, x: GLdouble) void {
    return (function_pointers.glVertexAttrib1d orelse @panic("glVertexAttrib1d was not bound."))(index, x);
}

pub fn vertexAttrib1dv(index: GLuint, v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib1dv orelse @panic("glVertexAttrib1dv was not bound."))(index, v);
}

pub fn vertexAttrib1f(index: GLuint, x: GLfloat) void {
    return (function_pointers.glVertexAttrib1f orelse @panic("glVertexAttrib1f was not bound."))(index, x);
}

pub fn vertexAttrib1fv(index: GLuint, v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib1fv orelse @panic("glVertexAttrib1fv was not bound."))(index, v);
}

pub fn vertexAttrib1s(index: GLuint, x: GLshort) void {
    return (function_pointers.glVertexAttrib1s orelse @panic("glVertexAttrib1s was not bound."))(index, x);
}

pub fn vertexAttrib1sv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib1sv orelse @panic("glVertexAttrib1sv was not bound."))(index, v);
}

pub fn vertexAttrib2d(index: GLuint, x: GLdouble, y: GLdouble) void {
    return (function_pointers.glVertexAttrib2d orelse @panic("glVertexAttrib2d was not bound."))(index, x, y);
}

pub fn vertexAttrib2dv(index: GLuint, v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib2dv orelse @panic("glVertexAttrib2dv was not bound."))(index, v);
}

pub fn vertexAttrib2f(index: GLuint, x: GLfloat, y: GLfloat) void {
    return (function_pointers.glVertexAttrib2f orelse @panic("glVertexAttrib2f was not bound."))(index, x, y);
}

pub fn vertexAttrib2fv(index: GLuint, v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib2fv orelse @panic("glVertexAttrib2fv was not bound."))(index, v);
}

pub fn vertexAttrib2s(index: GLuint, x: GLshort, y: GLshort) void {
    return (function_pointers.glVertexAttrib2s orelse @panic("glVertexAttrib2s was not bound."))(index, x, y);
}

pub fn vertexAttrib2sv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib2sv orelse @panic("glVertexAttrib2sv was not bound."))(index, v);
}

pub fn vertexAttrib3d(index: GLuint, x: GLdouble, y: GLdouble, z: GLdouble) void {
    return (function_pointers.glVertexAttrib3d orelse @panic("glVertexAttrib3d was not bound."))(index, x, y, z);
}

pub fn vertexAttrib3dv(index: GLuint, v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib3dv orelse @panic("glVertexAttrib3dv was not bound."))(index, v);
}

pub fn vertexAttrib3f(index: GLuint, x: GLfloat, y: GLfloat, z: GLfloat) void {
    return (function_pointers.glVertexAttrib3f orelse @panic("glVertexAttrib3f was not bound."))(index, x, y, z);
}

pub fn vertexAttrib3fv(index: GLuint, v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib3fv orelse @panic("glVertexAttrib3fv was not bound."))(index, v);
}

pub fn vertexAttrib3s(index: GLuint, x: GLshort, y: GLshort, z: GLshort) void {
    return (function_pointers.glVertexAttrib3s orelse @panic("glVertexAttrib3s was not bound."))(index, x, y, z);
}

pub fn vertexAttrib3sv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib3sv orelse @panic("glVertexAttrib3sv was not bound."))(index, v);
}

pub fn vertexAttrib4Nbv(index: GLuint, v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttrib4Nbv orelse @panic("glVertexAttrib4Nbv was not bound."))(index, v);
}

pub fn vertexAttrib4Niv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttrib4Niv orelse @panic("glVertexAttrib4Niv was not bound."))(index, v);
}

pub fn vertexAttrib4Nsv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib4Nsv orelse @panic("glVertexAttrib4Nsv was not bound."))(index, v);
}

pub fn vertexAttrib4Nub(index: GLuint, x: GLubyte, y: GLubyte, z: GLubyte, w: GLubyte) void {
    return (function_pointers.glVertexAttrib4Nub orelse @panic("glVertexAttrib4Nub was not bound."))(index, x, y, z, w);
}

pub fn vertexAttrib4Nubv(index: GLuint, v: [*:0]const GLubyte) void {
    return (function_pointers.glVertexAttrib4Nubv orelse @panic("glVertexAttrib4Nubv was not bound."))(index, v);
}

pub fn vertexAttrib4Nuiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttrib4Nuiv orelse @panic("glVertexAttrib4Nuiv was not bound."))(index, v);
}

pub fn vertexAttrib4Nusv(index: GLuint, v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttrib4Nusv orelse @panic("glVertexAttrib4Nusv was not bound."))(index, v);
}

pub fn vertexAttrib4bv(index: GLuint, v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttrib4bv orelse @panic("glVertexAttrib4bv was not bound."))(index, v);
}

pub fn vertexAttrib4d(index: GLuint, x: GLdouble, y: GLdouble, z: GLdouble, w: GLdouble) void {
    return (function_pointers.glVertexAttrib4d orelse @panic("glVertexAttrib4d was not bound."))(index, x, y, z, w);
}

pub fn vertexAttrib4dv(index: GLuint, v: [*c]const GLdouble) void {
    return (function_pointers.glVertexAttrib4dv orelse @panic("glVertexAttrib4dv was not bound."))(index, v);
}

pub fn vertexAttrib4f(index: GLuint, x: GLfloat, y: GLfloat, z: GLfloat, w: GLfloat) void {
    return (function_pointers.glVertexAttrib4f orelse @panic("glVertexAttrib4f was not bound."))(index, x, y, z, w);
}

pub fn vertexAttrib4fv(index: GLuint, v: [*c]const GLfloat) void {
    return (function_pointers.glVertexAttrib4fv orelse @panic("glVertexAttrib4fv was not bound."))(index, v);
}

pub fn vertexAttrib4iv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttrib4iv orelse @panic("glVertexAttrib4iv was not bound."))(index, v);
}

pub fn vertexAttrib4s(index: GLuint, x: GLshort, y: GLshort, z: GLshort, w: GLshort) void {
    return (function_pointers.glVertexAttrib4s orelse @panic("glVertexAttrib4s was not bound."))(index, x, y, z, w);
}

pub fn vertexAttrib4sv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttrib4sv orelse @panic("glVertexAttrib4sv was not bound."))(index, v);
}

pub fn vertexAttrib4ubv(index: GLuint, v: [*:0]const GLubyte) void {
    return (function_pointers.glVertexAttrib4ubv orelse @panic("glVertexAttrib4ubv was not bound."))(index, v);
}

pub fn vertexAttrib4uiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttrib4uiv orelse @panic("glVertexAttrib4uiv was not bound."))(index, v);
}

pub fn vertexAttrib4usv(index: GLuint, v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttrib4usv orelse @panic("glVertexAttrib4usv was not bound."))(index, v);
}

pub fn vertexAttribPointer(index: GLuint, size: GLint, type: GLenum, normalized: GLboolean, stride: GLsizei, pointer: *const c_void) void {
    return (function_pointers.glVertexAttribPointer orelse @panic("glVertexAttribPointer was not bound."))(index, size, type, normalized, stride, pointer);
}

pub fn uniformMatrix2x3fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2x3fv orelse @panic("glUniformMatrix2x3fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix3x2fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3x2fv orelse @panic("glUniformMatrix3x2fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix2x4fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix2x4fv orelse @panic("glUniformMatrix2x4fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix4x2fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4x2fv orelse @panic("glUniformMatrix4x2fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix3x4fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix3x4fv orelse @panic("glUniformMatrix3x4fv was not bound."))(location, count, transpose, value);
}

pub fn uniformMatrix4x3fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    return (function_pointers.glUniformMatrix4x3fv orelse @panic("glUniformMatrix4x3fv was not bound."))(location, count, transpose, value);
}

pub fn colorMaski(index: GLuint, r: GLboolean, g: GLboolean, b: GLboolean, a: GLboolean) void {
    return (function_pointers.glColorMaski orelse @panic("glColorMaski was not bound."))(index, r, g, b, a);
}

pub fn getBooleani_v(target: GLenum, index: GLuint, data: [*c]GLboolean) void {
    return (function_pointers.glGetBooleani_v orelse @panic("glGetBooleani_v was not bound."))(target, index, data);
}

pub fn getIntegeri_v(target: GLenum, index: GLuint, data: [*c]GLint) void {
    return (function_pointers.glGetIntegeri_v orelse @panic("glGetIntegeri_v was not bound."))(target, index, data);
}

pub fn enablei(target: GLenum, index: GLuint) void {
    return (function_pointers.glEnablei orelse @panic("glEnablei was not bound."))(target, index);
}

pub fn disablei(target: GLenum, index: GLuint) void {
    return (function_pointers.glDisablei orelse @panic("glDisablei was not bound."))(target, index);
}

pub fn isEnabledi(target: GLenum, index: GLuint) GLboolean {
    return (function_pointers.glIsEnabledi orelse @panic("glIsEnabledi was not bound."))(target, index);
}

pub fn beginTransformFeedback(primitiveMode: GLenum) void {
    return (function_pointers.glBeginTransformFeedback orelse @panic("glBeginTransformFeedback was not bound."))(primitiveMode);
}

pub fn endTransformFeedback() void {
    return (function_pointers.glEndTransformFeedback orelse @panic("glEndTransformFeedback was not bound."))();
}

pub fn bindBufferRange(target: GLenum, index: GLuint, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void {
    return (function_pointers.glBindBufferRange orelse @panic("glBindBufferRange was not bound."))(target, index, buffer, offset, size);
}

pub fn bindBufferBase(target: GLenum, index: GLuint, buffer: GLuint) void {
    return (function_pointers.glBindBufferBase orelse @panic("glBindBufferBase was not bound."))(target, index, buffer);
}

pub fn transformFeedbackVaryings(program: GLuint, count: GLsizei, varyings: [*c]const [*c]const GLchar, bufferMode: GLenum) void {
    return (function_pointers.glTransformFeedbackVaryings orelse @panic("glTransformFeedbackVaryings was not bound."))(program, count, varyings, bufferMode);
}

pub fn getTransformFeedbackVarying(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLsizei, type: [*c]GLenum, name: [*c]GLchar) void {
    return (function_pointers.glGetTransformFeedbackVarying orelse @panic("glGetTransformFeedbackVarying was not bound."))(program, index, bufSize, length, size, type, name);
}

pub fn clampColor(target: GLenum, clamp: GLenum) void {
    return (function_pointers.glClampColor orelse @panic("glClampColor was not bound."))(target, clamp);
}

pub fn beginConditionalRender(id: GLuint, mode: GLenum) void {
    return (function_pointers.glBeginConditionalRender orelse @panic("glBeginConditionalRender was not bound."))(id, mode);
}

pub fn endConditionalRender() void {
    return (function_pointers.glEndConditionalRender orelse @panic("glEndConditionalRender was not bound."))();
}

pub fn vertexAttribIPointer(index: GLuint, size: GLint, type: GLenum, stride: GLsizei, pointer: *const c_void) void {
    return (function_pointers.glVertexAttribIPointer orelse @panic("glVertexAttribIPointer was not bound."))(index, size, type, stride, pointer);
}

pub fn getVertexAttribIiv(index: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetVertexAttribIiv orelse @panic("glGetVertexAttribIiv was not bound."))(index, pname, params);
}

pub fn getVertexAttribIuiv(index: GLuint, pname: GLenum, params: [*c]GLuint) void {
    return (function_pointers.glGetVertexAttribIuiv orelse @panic("glGetVertexAttribIuiv was not bound."))(index, pname, params);
}

pub fn vertexAttribI1i(index: GLuint, x: GLint) void {
    return (function_pointers.glVertexAttribI1i orelse @panic("glVertexAttribI1i was not bound."))(index, x);
}

pub fn vertexAttribI2i(index: GLuint, x: GLint, y: GLint) void {
    return (function_pointers.glVertexAttribI2i orelse @panic("glVertexAttribI2i was not bound."))(index, x, y);
}

pub fn vertexAttribI3i(index: GLuint, x: GLint, y: GLint, z: GLint) void {
    return (function_pointers.glVertexAttribI3i orelse @panic("glVertexAttribI3i was not bound."))(index, x, y, z);
}

pub fn vertexAttribI4i(index: GLuint, x: GLint, y: GLint, z: GLint, w: GLint) void {
    return (function_pointers.glVertexAttribI4i orelse @panic("glVertexAttribI4i was not bound."))(index, x, y, z, w);
}

pub fn vertexAttribI1ui(index: GLuint, x: GLuint) void {
    return (function_pointers.glVertexAttribI1ui orelse @panic("glVertexAttribI1ui was not bound."))(index, x);
}

pub fn vertexAttribI2ui(index: GLuint, x: GLuint, y: GLuint) void {
    return (function_pointers.glVertexAttribI2ui orelse @panic("glVertexAttribI2ui was not bound."))(index, x, y);
}

pub fn vertexAttribI3ui(index: GLuint, x: GLuint, y: GLuint, z: GLuint) void {
    return (function_pointers.glVertexAttribI3ui orelse @panic("glVertexAttribI3ui was not bound."))(index, x, y, z);
}

pub fn vertexAttribI4ui(index: GLuint, x: GLuint, y: GLuint, z: GLuint, w: GLuint) void {
    return (function_pointers.glVertexAttribI4ui orelse @panic("glVertexAttribI4ui was not bound."))(index, x, y, z, w);
}

pub fn vertexAttribI1iv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI1iv orelse @panic("glVertexAttribI1iv was not bound."))(index, v);
}

pub fn vertexAttribI2iv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI2iv orelse @panic("glVertexAttribI2iv was not bound."))(index, v);
}

pub fn vertexAttribI3iv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI3iv orelse @panic("glVertexAttribI3iv was not bound."))(index, v);
}

pub fn vertexAttribI4iv(index: GLuint, v: [*c]const GLint) void {
    return (function_pointers.glVertexAttribI4iv orelse @panic("glVertexAttribI4iv was not bound."))(index, v);
}

pub fn vertexAttribI1uiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI1uiv orelse @panic("glVertexAttribI1uiv was not bound."))(index, v);
}

pub fn vertexAttribI2uiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI2uiv orelse @panic("glVertexAttribI2uiv was not bound."))(index, v);
}

pub fn vertexAttribI3uiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI3uiv orelse @panic("glVertexAttribI3uiv was not bound."))(index, v);
}

pub fn vertexAttribI4uiv(index: GLuint, v: [*c]const GLuint) void {
    return (function_pointers.glVertexAttribI4uiv orelse @panic("glVertexAttribI4uiv was not bound."))(index, v);
}

pub fn vertexAttribI4bv(index: GLuint, v: [*c]const GLbyte) void {
    return (function_pointers.glVertexAttribI4bv orelse @panic("glVertexAttribI4bv was not bound."))(index, v);
}

pub fn vertexAttribI4sv(index: GLuint, v: [*c]const GLshort) void {
    return (function_pointers.glVertexAttribI4sv orelse @panic("glVertexAttribI4sv was not bound."))(index, v);
}

pub fn vertexAttribI4ubv(index: GLuint, v: [*:0]const GLubyte) void {
    return (function_pointers.glVertexAttribI4ubv orelse @panic("glVertexAttribI4ubv was not bound."))(index, v);
}

pub fn vertexAttribI4usv(index: GLuint, v: [*c]const GLushort) void {
    return (function_pointers.glVertexAttribI4usv orelse @panic("glVertexAttribI4usv was not bound."))(index, v);
}

pub fn getUniformuiv(program: GLuint, location: GLint, params: [*c]GLuint) void {
    return (function_pointers.glGetUniformuiv orelse @panic("glGetUniformuiv was not bound."))(program, location, params);
}

pub fn bindFragDataLocation(program: GLuint, color: GLuint, name: [*c]const GLchar) void {
    return (function_pointers.glBindFragDataLocation orelse @panic("glBindFragDataLocation was not bound."))(program, color, name);
}

pub fn getFragDataLocation(program: GLuint, name: [*c]const GLchar) GLint {
    return (function_pointers.glGetFragDataLocation orelse @panic("glGetFragDataLocation was not bound."))(program, name);
}

pub fn uniform1ui(location: GLint, v0: GLuint) void {
    return (function_pointers.glUniform1ui orelse @panic("glUniform1ui was not bound."))(location, v0);
}

pub fn uniform2ui(location: GLint, v0: GLuint, v1: GLuint) void {
    return (function_pointers.glUniform2ui orelse @panic("glUniform2ui was not bound."))(location, v0, v1);
}

pub fn uniform3ui(location: GLint, v0: GLuint, v1: GLuint, v2: GLuint) void {
    return (function_pointers.glUniform3ui orelse @panic("glUniform3ui was not bound."))(location, v0, v1, v2);
}

pub fn uniform4ui(location: GLint, v0: GLuint, v1: GLuint, v2: GLuint, v3: GLuint) void {
    return (function_pointers.glUniform4ui orelse @panic("glUniform4ui was not bound."))(location, v0, v1, v2, v3);
}

pub fn uniform1uiv(location: GLint, count: GLsizei, value: [*c]const GLuint) void {
    return (function_pointers.glUniform1uiv orelse @panic("glUniform1uiv was not bound."))(location, count, value);
}

pub fn uniform2uiv(location: GLint, count: GLsizei, value: [*c]const GLuint) void {
    return (function_pointers.glUniform2uiv orelse @panic("glUniform2uiv was not bound."))(location, count, value);
}

pub fn uniform3uiv(location: GLint, count: GLsizei, value: [*c]const GLuint) void {
    return (function_pointers.glUniform3uiv orelse @panic("glUniform3uiv was not bound."))(location, count, value);
}

pub fn uniform4uiv(location: GLint, count: GLsizei, value: [*c]const GLuint) void {
    return (function_pointers.glUniform4uiv orelse @panic("glUniform4uiv was not bound."))(location, count, value);
}

pub fn texParameterIiv(target: GLenum, pname: GLenum, params: [*c]const GLint) void {
    return (function_pointers.glTexParameterIiv orelse @panic("glTexParameterIiv was not bound."))(target, pname, params);
}

pub fn texParameterIuiv(target: GLenum, pname: GLenum, params: [*c]const GLuint) void {
    return (function_pointers.glTexParameterIuiv orelse @panic("glTexParameterIuiv was not bound."))(target, pname, params);
}

pub fn getTexParameterIiv(target: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTexParameterIiv orelse @panic("glGetTexParameterIiv was not bound."))(target, pname, params);
}

pub fn getTexParameterIuiv(target: GLenum, pname: GLenum, params: [*c]GLuint) void {
    return (function_pointers.glGetTexParameterIuiv orelse @panic("glGetTexParameterIuiv was not bound."))(target, pname, params);
}

pub fn clearBufferiv(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLint) void {
    return (function_pointers.glClearBufferiv orelse @panic("glClearBufferiv was not bound."))(buffer, drawbuffer, value);
}

pub fn clearBufferuiv(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLuint) void {
    return (function_pointers.glClearBufferuiv orelse @panic("glClearBufferuiv was not bound."))(buffer, drawbuffer, value);
}

pub fn clearBufferfv(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLfloat) void {
    return (function_pointers.glClearBufferfv orelse @panic("glClearBufferfv was not bound."))(buffer, drawbuffer, value);
}

pub fn clearBufferfi(buffer: GLenum, drawbuffer: GLint, depth: GLfloat, stencil: GLint) void {
    return (function_pointers.glClearBufferfi orelse @panic("glClearBufferfi was not bound."))(buffer, drawbuffer, depth, stencil);
}

pub fn getStringi(name: GLenum, index: GLuint) [*:0]const GLubyte {
    return (function_pointers.glGetStringi orelse @panic("glGetStringi was not bound."))(name, index);
}

pub fn isRenderbuffer(renderbuffer: GLuint) GLboolean {
    return (function_pointers.glIsRenderbuffer orelse @panic("glIsRenderbuffer was not bound."))(renderbuffer);
}

pub fn bindRenderbuffer(target: GLenum, renderbuffer: GLuint) void {
    return (function_pointers.glBindRenderbuffer orelse @panic("glBindRenderbuffer was not bound."))(target, renderbuffer);
}

pub fn deleteRenderbuffers(n: GLsizei, renderbuffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteRenderbuffers orelse @panic("glDeleteRenderbuffers was not bound."))(n, renderbuffers);
}

pub fn genRenderbuffers(n: GLsizei, renderbuffers: [*c]GLuint) void {
    return (function_pointers.glGenRenderbuffers orelse @panic("glGenRenderbuffers was not bound."))(n, renderbuffers);
}

pub fn renderbufferStorage(target: GLenum, internalformat: GLenum, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glRenderbufferStorage orelse @panic("glRenderbufferStorage was not bound."))(target, internalformat, width, height);
}

pub fn getRenderbufferParameteriv(target: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetRenderbufferParameteriv orelse @panic("glGetRenderbufferParameteriv was not bound."))(target, pname, params);
}

pub fn isFramebuffer(framebuffer: GLuint) GLboolean {
    return (function_pointers.glIsFramebuffer orelse @panic("glIsFramebuffer was not bound."))(framebuffer);
}

pub fn bindFramebuffer(target: GLenum, framebuffer: GLuint) void {
    return (function_pointers.glBindFramebuffer orelse @panic("glBindFramebuffer was not bound."))(target, framebuffer);
}

pub fn deleteFramebuffers(n: GLsizei, framebuffers: [*c]const GLuint) void {
    return (function_pointers.glDeleteFramebuffers orelse @panic("glDeleteFramebuffers was not bound."))(n, framebuffers);
}

pub fn genFramebuffers(n: GLsizei, framebuffers: [*c]GLuint) void {
    return (function_pointers.glGenFramebuffers orelse @panic("glGenFramebuffers was not bound."))(n, framebuffers);
}

pub fn checkFramebufferStatus(target: GLenum) GLenum {
    return (function_pointers.glCheckFramebufferStatus orelse @panic("glCheckFramebufferStatus was not bound."))(target);
}

pub fn framebufferTexture1D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint) void {
    return (function_pointers.glFramebufferTexture1D orelse @panic("glFramebufferTexture1D was not bound."))(target, attachment, textarget, texture, level);
}

pub fn framebufferTexture2D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint) void {
    return (function_pointers.glFramebufferTexture2D orelse @panic("glFramebufferTexture2D was not bound."))(target, attachment, textarget, texture, level);
}

pub fn framebufferTexture3D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint, zoffset: GLint) void {
    return (function_pointers.glFramebufferTexture3D orelse @panic("glFramebufferTexture3D was not bound."))(target, attachment, textarget, texture, level, zoffset);
}

pub fn framebufferRenderbuffer(target: GLenum, attachment: GLenum, renderbuffertarget: GLenum, renderbuffer: GLuint) void {
    return (function_pointers.glFramebufferRenderbuffer orelse @panic("glFramebufferRenderbuffer was not bound."))(target, attachment, renderbuffertarget, renderbuffer);
}

pub fn getFramebufferAttachmentParameteriv(target: GLenum, attachment: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetFramebufferAttachmentParameteriv orelse @panic("glGetFramebufferAttachmentParameteriv was not bound."))(target, attachment, pname, params);
}

pub fn generateMipmap(target: GLenum) void {
    return (function_pointers.glGenerateMipmap orelse @panic("glGenerateMipmap was not bound."))(target);
}

pub fn blitFramebuffer(srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum) void {
    return (function_pointers.glBlitFramebuffer orelse @panic("glBlitFramebuffer was not bound."))(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
}

pub fn renderbufferStorageMultisample(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glRenderbufferStorageMultisample orelse @panic("glRenderbufferStorageMultisample was not bound."))(target, samples, internalformat, width, height);
}

pub fn framebufferTextureLayer(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint, layer: GLint) void {
    return (function_pointers.glFramebufferTextureLayer orelse @panic("glFramebufferTextureLayer was not bound."))(target, attachment, texture, level, layer);
}

pub fn mapBufferRange(target: GLenum, offset: GLintptr, length: GLsizeiptr, access: GLbitfield) *c_void {
    return (function_pointers.glMapBufferRange orelse @panic("glMapBufferRange was not bound."))(target, offset, length, access);
}

pub fn flushMappedBufferRange(target: GLenum, offset: GLintptr, length: GLsizeiptr) void {
    return (function_pointers.glFlushMappedBufferRange orelse @panic("glFlushMappedBufferRange was not bound."))(target, offset, length);
}

pub fn bindVertexArray(array: GLuint) void {
    return (function_pointers.glBindVertexArray orelse @panic("glBindVertexArray was not bound."))(array);
}

pub fn deleteVertexArrays(n: GLsizei, arrays: [*c]const GLuint) void {
    return (function_pointers.glDeleteVertexArrays orelse @panic("glDeleteVertexArrays was not bound."))(n, arrays);
}

pub fn genVertexArrays(n: GLsizei, arrays: [*c]GLuint) void {
    return (function_pointers.glGenVertexArrays orelse @panic("glGenVertexArrays was not bound."))(n, arrays);
}

pub fn isVertexArray(array: GLuint) GLboolean {
    return (function_pointers.glIsVertexArray orelse @panic("glIsVertexArray was not bound."))(array);
}

pub fn drawArraysInstanced(mode: GLenum, first: GLint, count: GLsizei, instancecount: GLsizei) void {
    return (function_pointers.glDrawArraysInstanced orelse @panic("glDrawArraysInstanced was not bound."))(mode, first, count, instancecount);
}

pub fn drawElementsInstanced(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, instancecount: GLsizei) void {
    return (function_pointers.glDrawElementsInstanced orelse @panic("glDrawElementsInstanced was not bound."))(mode, count, type, indices, instancecount);
}

pub fn texBuffer(target: GLenum, internalformat: GLenum, buffer: GLuint) void {
    return (function_pointers.glTexBuffer orelse @panic("glTexBuffer was not bound."))(target, internalformat, buffer);
}

pub fn primitiveRestartIndex(index: GLuint) void {
    return (function_pointers.glPrimitiveRestartIndex orelse @panic("glPrimitiveRestartIndex was not bound."))(index);
}

pub fn copyBufferSubData(readTarget: GLenum, writeTarget: GLenum, readOffset: GLintptr, writeOffset: GLintptr, size: GLsizeiptr) void {
    return (function_pointers.glCopyBufferSubData orelse @panic("glCopyBufferSubData was not bound."))(readTarget, writeTarget, readOffset, writeOffset, size);
}

pub fn getUniformIndices(program: GLuint, uniformCount: GLsizei, uniformNames: [*c]const [*c]const GLchar, uniformIndices: [*c]GLuint) void {
    return (function_pointers.glGetUniformIndices orelse @panic("glGetUniformIndices was not bound."))(program, uniformCount, uniformNames, uniformIndices);
}

pub fn getActiveUniformsiv(program: GLuint, uniformCount: GLsizei, uniformIndices: [*c]const GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetActiveUniformsiv orelse @panic("glGetActiveUniformsiv was not bound."))(program, uniformCount, uniformIndices, pname, params);
}

pub fn getActiveUniformName(program: GLuint, uniformIndex: GLuint, bufSize: GLsizei, length: [*c]GLsizei, uniformName: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniformName orelse @panic("glGetActiveUniformName was not bound."))(program, uniformIndex, bufSize, length, uniformName);
}

pub fn getUniformBlockIndex(program: GLuint, uniformBlockName: [*c]const GLchar) GLuint {
    return (function_pointers.glGetUniformBlockIndex orelse @panic("glGetUniformBlockIndex was not bound."))(program, uniformBlockName);
}

pub fn getActiveUniformBlockiv(program: GLuint, uniformBlockIndex: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetActiveUniformBlockiv orelse @panic("glGetActiveUniformBlockiv was not bound."))(program, uniformBlockIndex, pname, params);
}

pub fn getActiveUniformBlockName(program: GLuint, uniformBlockIndex: GLuint, bufSize: GLsizei, length: [*c]GLsizei, uniformBlockName: [*c]GLchar) void {
    return (function_pointers.glGetActiveUniformBlockName orelse @panic("glGetActiveUniformBlockName was not bound."))(program, uniformBlockIndex, bufSize, length, uniformBlockName);
}

pub fn uniformBlockBinding(program: GLuint, uniformBlockIndex: GLuint, uniformBlockBinding: GLuint) void {
    return (function_pointers.glUniformBlockBinding orelse @panic("glUniformBlockBinding was not bound."))(program, uniformBlockIndex, uniformBlockBinding);
}
// Extensions:

pub const GL_ARB_direct_state_access = struct {
pub const TEXTURE_TARGET = 0x1006;
pub const QUERY_TARGET = 0x82EA;
pub const TEXTURE_BINDING_1D = 0x8068;
pub const TEXTURE_BINDING_1D_ARRAY = 0x8C1C;
pub const TEXTURE_BINDING_2D = 0x8069;
pub const TEXTURE_BINDING_2D_ARRAY = 0x8C1D;
pub const TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104;
pub const TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105;
pub const TEXTURE_BINDING_3D = 0x806A;
pub const TEXTURE_BINDING_BUFFER = 0x8C2C;
pub const TEXTURE_BINDING_CUBE_MAP = 0x8514;
pub const TEXTURE_BINDING_CUBE_MAP_ARRAY = 0x900A;
pub const TEXTURE_BINDING_RECTANGLE = 0x84F6;


pub fn createTransformFeedbacks(n: GLsizei, ids: [*c]GLuint) void {
    return (function_pointers.glCreateTransformFeedbacks orelse @panic("glCreateTransformFeedbacks was not bound."))(n, ids);
}

pub fn transformFeedbackBufferBase(xfb: GLuint, index: GLuint, buffer: GLuint) void {
    return (function_pointers.glTransformFeedbackBufferBase orelse @panic("glTransformFeedbackBufferBase was not bound."))(xfb, index, buffer);
}

pub fn transformFeedbackBufferRange(xfb: GLuint, index: GLuint, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void {
    return (function_pointers.glTransformFeedbackBufferRange orelse @panic("glTransformFeedbackBufferRange was not bound."))(xfb, index, buffer, offset, size);
}

pub fn getTransformFeedbackiv(xfb: GLuint, pname: GLenum, param: [*c]GLint) void {
    return (function_pointers.glGetTransformFeedbackiv orelse @panic("glGetTransformFeedbackiv was not bound."))(xfb, pname, param);
}

pub fn getTransformFeedbacki_v(xfb: GLuint, pname: GLenum, index: GLuint, param: [*c]GLint) void {
    return (function_pointers.glGetTransformFeedbacki_v orelse @panic("glGetTransformFeedbacki_v was not bound."))(xfb, pname, index, param);
}

pub fn getTransformFeedbacki64_v(xfb: GLuint, pname: GLenum, index: GLuint, param: [*c]GLint64) void {
    return (function_pointers.glGetTransformFeedbacki64_v orelse @panic("glGetTransformFeedbacki64_v was not bound."))(xfb, pname, index, param);
}

pub fn createBuffers(n: GLsizei, buffers: [*c]GLuint) void {
    return (function_pointers.glCreateBuffers orelse @panic("glCreateBuffers was not bound."))(n, buffers);
}

pub fn namedBufferStorage(buffer: GLuint, size: GLsizeiptr, data: *const c_void, flags: GLbitfield) void {
    return (function_pointers.glNamedBufferStorage orelse @panic("glNamedBufferStorage was not bound."))(buffer, size, data, flags);
}

pub fn namedBufferData(buffer: GLuint, size: GLsizeiptr, data: *const c_void, usage: GLenum) void {
    return (function_pointers.glNamedBufferData orelse @panic("glNamedBufferData was not bound."))(buffer, size, data, usage);
}

pub fn namedBufferSubData(buffer: GLuint, offset: GLintptr, size: GLsizeiptr, data: *const c_void) void {
    return (function_pointers.glNamedBufferSubData orelse @panic("glNamedBufferSubData was not bound."))(buffer, offset, size, data);
}

pub fn copyNamedBufferSubData(readBuffer: GLuint, writeBuffer: GLuint, readOffset: GLintptr, writeOffset: GLintptr, size: GLsizeiptr) void {
    return (function_pointers.glCopyNamedBufferSubData orelse @panic("glCopyNamedBufferSubData was not bound."))(readBuffer, writeBuffer, readOffset, writeOffset, size);
}

pub fn clearNamedBufferData(buffer: GLuint, internalformat: GLenum, format: GLenum, type: GLenum, data: *const c_void) void {
    return (function_pointers.glClearNamedBufferData orelse @panic("glClearNamedBufferData was not bound."))(buffer, internalformat, format, type, data);
}

pub fn clearNamedBufferSubData(buffer: GLuint, internalformat: GLenum, offset: GLintptr, size: GLsizeiptr, format: GLenum, type: GLenum, data: *const c_void) void {
    return (function_pointers.glClearNamedBufferSubData orelse @panic("glClearNamedBufferSubData was not bound."))(buffer, internalformat, offset, size, format, type, data);
}

pub fn mapNamedBuffer(buffer: GLuint, access: GLenum) *c_void {
    return (function_pointers.glMapNamedBuffer orelse @panic("glMapNamedBuffer was not bound."))(buffer, access);
}

pub fn mapNamedBufferRange(buffer: GLuint, offset: GLintptr, length: GLsizeiptr, access: GLbitfield) *c_void {
    return (function_pointers.glMapNamedBufferRange orelse @panic("glMapNamedBufferRange was not bound."))(buffer, offset, length, access);
}

pub fn unmapNamedBuffer(buffer: GLuint) GLboolean {
    return (function_pointers.glUnmapNamedBuffer orelse @panic("glUnmapNamedBuffer was not bound."))(buffer);
}

pub fn flushMappedNamedBufferRange(buffer: GLuint, offset: GLintptr, length: GLsizeiptr) void {
    return (function_pointers.glFlushMappedNamedBufferRange orelse @panic("glFlushMappedNamedBufferRange was not bound."))(buffer, offset, length);
}

pub fn getNamedBufferParameteriv(buffer: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetNamedBufferParameteriv orelse @panic("glGetNamedBufferParameteriv was not bound."))(buffer, pname, params);
}

pub fn getNamedBufferParameteri64v(buffer: GLuint, pname: GLenum, params: [*c]GLint64) void {
    return (function_pointers.glGetNamedBufferParameteri64v orelse @panic("glGetNamedBufferParameteri64v was not bound."))(buffer, pname, params);
}

pub fn getNamedBufferPointerv(buffer: GLuint, pname: GLenum, params: **c_void) void {
    return (function_pointers.glGetNamedBufferPointerv orelse @panic("glGetNamedBufferPointerv was not bound."))(buffer, pname, params);
}

pub fn getNamedBufferSubData(buffer: GLuint, offset: GLintptr, size: GLsizeiptr, data: *c_void) void {
    return (function_pointers.glGetNamedBufferSubData orelse @panic("glGetNamedBufferSubData was not bound."))(buffer, offset, size, data);
}

pub fn createFramebuffers(n: GLsizei, framebuffers: [*c]GLuint) void {
    return (function_pointers.glCreateFramebuffers orelse @panic("glCreateFramebuffers was not bound."))(n, framebuffers);
}

pub fn namedFramebufferRenderbuffer(framebuffer: GLuint, attachment: GLenum, renderbuffertarget: GLenum, renderbuffer: GLuint) void {
    return (function_pointers.glNamedFramebufferRenderbuffer orelse @panic("glNamedFramebufferRenderbuffer was not bound."))(framebuffer, attachment, renderbuffertarget, renderbuffer);
}

pub fn namedFramebufferParameteri(framebuffer: GLuint, pname: GLenum, param: GLint) void {
    return (function_pointers.glNamedFramebufferParameteri orelse @panic("glNamedFramebufferParameteri was not bound."))(framebuffer, pname, param);
}

pub fn namedFramebufferTexture(framebuffer: GLuint, attachment: GLenum, texture: GLuint, level: GLint) void {
    return (function_pointers.glNamedFramebufferTexture orelse @panic("glNamedFramebufferTexture was not bound."))(framebuffer, attachment, texture, level);
}

pub fn namedFramebufferTextureLayer(framebuffer: GLuint, attachment: GLenum, texture: GLuint, level: GLint, layer: GLint) void {
    return (function_pointers.glNamedFramebufferTextureLayer orelse @panic("glNamedFramebufferTextureLayer was not bound."))(framebuffer, attachment, texture, level, layer);
}

pub fn namedFramebufferDrawBuffer(framebuffer: GLuint, buf: GLenum) void {
    return (function_pointers.glNamedFramebufferDrawBuffer orelse @panic("glNamedFramebufferDrawBuffer was not bound."))(framebuffer, buf);
}

pub fn namedFramebufferDrawBuffers(framebuffer: GLuint, n: GLsizei, bufs: [*c]const GLenum) void {
    return (function_pointers.glNamedFramebufferDrawBuffers orelse @panic("glNamedFramebufferDrawBuffers was not bound."))(framebuffer, n, bufs);
}

pub fn namedFramebufferReadBuffer(framebuffer: GLuint, src: GLenum) void {
    return (function_pointers.glNamedFramebufferReadBuffer orelse @panic("glNamedFramebufferReadBuffer was not bound."))(framebuffer, src);
}

pub fn invalidateNamedFramebufferData(framebuffer: GLuint, numAttachments: GLsizei, attachments: [*c]const GLenum) void {
    return (function_pointers.glInvalidateNamedFramebufferData orelse @panic("glInvalidateNamedFramebufferData was not bound."))(framebuffer, numAttachments, attachments);
}

pub fn invalidateNamedFramebufferSubData(framebuffer: GLuint, numAttachments: GLsizei, attachments: [*c]const GLenum, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glInvalidateNamedFramebufferSubData orelse @panic("glInvalidateNamedFramebufferSubData was not bound."))(framebuffer, numAttachments, attachments, x, y, width, height);
}

pub fn clearNamedFramebufferiv(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLint) void {
    return (function_pointers.glClearNamedFramebufferiv orelse @panic("glClearNamedFramebufferiv was not bound."))(framebuffer, buffer, drawbuffer, value);
}

pub fn clearNamedFramebufferuiv(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLuint) void {
    return (function_pointers.glClearNamedFramebufferuiv orelse @panic("glClearNamedFramebufferuiv was not bound."))(framebuffer, buffer, drawbuffer, value);
}

pub fn clearNamedFramebufferfv(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLfloat) void {
    return (function_pointers.glClearNamedFramebufferfv orelse @panic("glClearNamedFramebufferfv was not bound."))(framebuffer, buffer, drawbuffer, value);
}

pub fn clearNamedFramebufferfi(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, depth: GLfloat, stencil: GLint) void {
    return (function_pointers.glClearNamedFramebufferfi orelse @panic("glClearNamedFramebufferfi was not bound."))(framebuffer, buffer, drawbuffer, depth, stencil);
}

pub fn blitNamedFramebuffer(readFramebuffer: GLuint, drawFramebuffer: GLuint, srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum) void {
    return (function_pointers.glBlitNamedFramebuffer orelse @panic("glBlitNamedFramebuffer was not bound."))(readFramebuffer, drawFramebuffer, srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
}

pub fn checkNamedFramebufferStatus(framebuffer: GLuint, target: GLenum) GLenum {
    return (function_pointers.glCheckNamedFramebufferStatus orelse @panic("glCheckNamedFramebufferStatus was not bound."))(framebuffer, target);
}

pub fn getNamedFramebufferParameteriv(framebuffer: GLuint, pname: GLenum, param: [*c]GLint) void {
    return (function_pointers.glGetNamedFramebufferParameteriv orelse @panic("glGetNamedFramebufferParameteriv was not bound."))(framebuffer, pname, param);
}

pub fn getNamedFramebufferAttachmentParameteriv(framebuffer: GLuint, attachment: GLenum, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetNamedFramebufferAttachmentParameteriv orelse @panic("glGetNamedFramebufferAttachmentParameteriv was not bound."))(framebuffer, attachment, pname, params);
}

pub fn createRenderbuffers(n: GLsizei, renderbuffers: [*c]GLuint) void {
    return (function_pointers.glCreateRenderbuffers orelse @panic("glCreateRenderbuffers was not bound."))(n, renderbuffers);
}

pub fn namedRenderbufferStorage(renderbuffer: GLuint, internalformat: GLenum, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glNamedRenderbufferStorage orelse @panic("glNamedRenderbufferStorage was not bound."))(renderbuffer, internalformat, width, height);
}

pub fn namedRenderbufferStorageMultisample(renderbuffer: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glNamedRenderbufferStorageMultisample orelse @panic("glNamedRenderbufferStorageMultisample was not bound."))(renderbuffer, samples, internalformat, width, height);
}

pub fn getNamedRenderbufferParameteriv(renderbuffer: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetNamedRenderbufferParameteriv orelse @panic("glGetNamedRenderbufferParameteriv was not bound."))(renderbuffer, pname, params);
}

pub fn createTextures(target: GLenum, n: GLsizei, textures: [*c]GLuint) void {
    return (function_pointers.glCreateTextures orelse @panic("glCreateTextures was not bound."))(target, n, textures);
}

pub fn textureBuffer(texture: GLuint, internalformat: GLenum, buffer: GLuint) void {
    return (function_pointers.glTextureBuffer orelse @panic("glTextureBuffer was not bound."))(texture, internalformat, buffer);
}

pub fn textureBufferRange(texture: GLuint, internalformat: GLenum, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void {
    return (function_pointers.glTextureBufferRange orelse @panic("glTextureBufferRange was not bound."))(texture, internalformat, buffer, offset, size);
}

pub fn textureStorage1D(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei) void {
    return (function_pointers.glTextureStorage1D orelse @panic("glTextureStorage1D was not bound."))(texture, levels, internalformat, width);
}

pub fn textureStorage2D(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glTextureStorage2D orelse @panic("glTextureStorage2D was not bound."))(texture, levels, internalformat, width, height);
}

pub fn textureStorage3D(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei) void {
    return (function_pointers.glTextureStorage3D orelse @panic("glTextureStorage3D was not bound."))(texture, levels, internalformat, width, height, depth);
}

pub fn textureStorage2DMultisample(texture: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTextureStorage2DMultisample orelse @panic("glTextureStorage2DMultisample was not bound."))(texture, samples, internalformat, width, height, fixedsamplelocations);
}

pub fn textureStorage3DMultisample(texture: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, fixedsamplelocations: GLboolean) void {
    return (function_pointers.glTextureStorage3DMultisample orelse @panic("glTextureStorage3DMultisample was not bound."))(texture, samples, internalformat, width, height, depth, fixedsamplelocations);
}

pub fn textureSubImage1D(texture: GLuint, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTextureSubImage1D orelse @panic("glTextureSubImage1D was not bound."))(texture, level, xoffset, width, format, type, pixels);
}

pub fn textureSubImage2D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTextureSubImage2D orelse @panic("glTextureSubImage2D was not bound."))(texture, level, xoffset, yoffset, width, height, format, type, pixels);
}

pub fn textureSubImage3D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void {
    return (function_pointers.glTextureSubImage3D orelse @panic("glTextureSubImage3D was not bound."))(texture, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
}

pub fn compressedTextureSubImage1D(texture: GLuint, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTextureSubImage1D orelse @panic("glCompressedTextureSubImage1D was not bound."))(texture, level, xoffset, width, format, imageSize, data);
}

pub fn compressedTextureSubImage2D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTextureSubImage2D orelse @panic("glCompressedTextureSubImage2D was not bound."))(texture, level, xoffset, yoffset, width, height, format, imageSize, data);
}

pub fn compressedTextureSubImage3D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void {
    return (function_pointers.glCompressedTextureSubImage3D orelse @panic("glCompressedTextureSubImage3D was not bound."))(texture, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
}

pub fn copyTextureSubImage1D(texture: GLuint, level: GLint, xoffset: GLint, x: GLint, y: GLint, width: GLsizei) void {
    return (function_pointers.glCopyTextureSubImage1D orelse @panic("glCopyTextureSubImage1D was not bound."))(texture, level, xoffset, x, y, width);
}

pub fn copyTextureSubImage2D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glCopyTextureSubImage2D orelse @panic("glCopyTextureSubImage2D was not bound."))(texture, level, xoffset, yoffset, x, y, width, height);
}

pub fn copyTextureSubImage3D(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void {
    return (function_pointers.glCopyTextureSubImage3D orelse @panic("glCopyTextureSubImage3D was not bound."))(texture, level, xoffset, yoffset, zoffset, x, y, width, height);
}

pub fn textureParameterf(texture: GLuint, pname: GLenum, param: GLfloat) void {
    return (function_pointers.glTextureParameterf orelse @panic("glTextureParameterf was not bound."))(texture, pname, param);
}

pub fn textureParameterfv(texture: GLuint, pname: GLenum, param: [*c]const GLfloat) void {
    return (function_pointers.glTextureParameterfv orelse @panic("glTextureParameterfv was not bound."))(texture, pname, param);
}

pub fn textureParameteri(texture: GLuint, pname: GLenum, param: GLint) void {
    return (function_pointers.glTextureParameteri orelse @panic("glTextureParameteri was not bound."))(texture, pname, param);
}

pub fn textureParameterIiv(texture: GLuint, pname: GLenum, params: [*c]const GLint) void {
    return (function_pointers.glTextureParameterIiv orelse @panic("glTextureParameterIiv was not bound."))(texture, pname, params);
}

pub fn textureParameterIuiv(texture: GLuint, pname: GLenum, params: [*c]const GLuint) void {
    return (function_pointers.glTextureParameterIuiv orelse @panic("glTextureParameterIuiv was not bound."))(texture, pname, params);
}

pub fn textureParameteriv(texture: GLuint, pname: GLenum, param: [*c]const GLint) void {
    return (function_pointers.glTextureParameteriv orelse @panic("glTextureParameteriv was not bound."))(texture, pname, param);
}

pub fn generateTextureMipmap(texture: GLuint) void {
    return (function_pointers.glGenerateTextureMipmap orelse @panic("glGenerateTextureMipmap was not bound."))(texture);
}

pub fn bindTextureUnit(unit: GLuint, texture: GLuint) void {
    return (function_pointers.glBindTextureUnit orelse @panic("glBindTextureUnit was not bound."))(unit, texture);
}

pub fn getTextureImage(texture: GLuint, level: GLint, format: GLenum, type: GLenum, bufSize: GLsizei, pixels: *c_void) void {
    return (function_pointers.glGetTextureImage orelse @panic("glGetTextureImage was not bound."))(texture, level, format, type, bufSize, pixels);
}

pub fn getCompressedTextureImage(texture: GLuint, level: GLint, bufSize: GLsizei, pixels: *c_void) void {
    return (function_pointers.glGetCompressedTextureImage orelse @panic("glGetCompressedTextureImage was not bound."))(texture, level, bufSize, pixels);
}

pub fn getTextureLevelParameterfv(texture: GLuint, level: GLint, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetTextureLevelParameterfv orelse @panic("glGetTextureLevelParameterfv was not bound."))(texture, level, pname, params);
}

pub fn getTextureLevelParameteriv(texture: GLuint, level: GLint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTextureLevelParameteriv orelse @panic("glGetTextureLevelParameteriv was not bound."))(texture, level, pname, params);
}

pub fn getTextureParameterfv(texture: GLuint, pname: GLenum, params: [*c]GLfloat) void {
    return (function_pointers.glGetTextureParameterfv orelse @panic("glGetTextureParameterfv was not bound."))(texture, pname, params);
}

pub fn getTextureParameterIiv(texture: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTextureParameterIiv orelse @panic("glGetTextureParameterIiv was not bound."))(texture, pname, params);
}

pub fn getTextureParameterIuiv(texture: GLuint, pname: GLenum, params: [*c]GLuint) void {
    return (function_pointers.glGetTextureParameterIuiv orelse @panic("glGetTextureParameterIuiv was not bound."))(texture, pname, params);
}

pub fn getTextureParameteriv(texture: GLuint, pname: GLenum, params: [*c]GLint) void {
    return (function_pointers.glGetTextureParameteriv orelse @panic("glGetTextureParameteriv was not bound."))(texture, pname, params);
}

pub fn createVertexArrays(n: GLsizei, arrays: [*c]GLuint) void {
    return (function_pointers.glCreateVertexArrays orelse @panic("glCreateVertexArrays was not bound."))(n, arrays);
}

pub fn disableVertexArrayAttrib(vaobj: GLuint, index: GLuint) void {
    return (function_pointers.glDisableVertexArrayAttrib orelse @panic("glDisableVertexArrayAttrib was not bound."))(vaobj, index);
}

pub fn enableVertexArrayAttrib(vaobj: GLuint, index: GLuint) void {
    return (function_pointers.glEnableVertexArrayAttrib orelse @panic("glEnableVertexArrayAttrib was not bound."))(vaobj, index);
}

pub fn vertexArrayElementBuffer(vaobj: GLuint, buffer: GLuint) void {
    return (function_pointers.glVertexArrayElementBuffer orelse @panic("glVertexArrayElementBuffer was not bound."))(vaobj, buffer);
}

pub fn vertexArrayVertexBuffer(vaobj: GLuint, bindingindex: GLuint, buffer: GLuint, offset: GLintptr, stride: GLsizei) void {
    return (function_pointers.glVertexArrayVertexBuffer orelse @panic("glVertexArrayVertexBuffer was not bound."))(vaobj, bindingindex, buffer, offset, stride);
}

pub fn vertexArrayVertexBuffers(vaobj: GLuint, first: GLuint, count: GLsizei, buffers: [*c]const GLuint, offsets: [*c]const GLintptr, strides: [*c]const GLsizei) void {
    return (function_pointers.glVertexArrayVertexBuffers orelse @panic("glVertexArrayVertexBuffers was not bound."))(vaobj, first, count, buffers, offsets, strides);
}

pub fn vertexArrayAttribBinding(vaobj: GLuint, attribindex: GLuint, bindingindex: GLuint) void {
    return (function_pointers.glVertexArrayAttribBinding orelse @panic("glVertexArrayAttribBinding was not bound."))(vaobj, attribindex, bindingindex);
}

pub fn vertexArrayAttribFormat(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, normalized: GLboolean, relativeoffset: GLuint) void {
    return (function_pointers.glVertexArrayAttribFormat orelse @panic("glVertexArrayAttribFormat was not bound."))(vaobj, attribindex, size, type, normalized, relativeoffset);
}

pub fn vertexArrayAttribIFormat(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, relativeoffset: GLuint) void {
    return (function_pointers.glVertexArrayAttribIFormat orelse @panic("glVertexArrayAttribIFormat was not bound."))(vaobj, attribindex, size, type, relativeoffset);
}

pub fn vertexArrayAttribLFormat(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, relativeoffset: GLuint) void {
    return (function_pointers.glVertexArrayAttribLFormat orelse @panic("glVertexArrayAttribLFormat was not bound."))(vaobj, attribindex, size, type, relativeoffset);
}

pub fn vertexArrayBindingDivisor(vaobj: GLuint, bindingindex: GLuint, divisor: GLuint) void {
    return (function_pointers.glVertexArrayBindingDivisor orelse @panic("glVertexArrayBindingDivisor was not bound."))(vaobj, bindingindex, divisor);
}

pub fn getVertexArrayiv(vaobj: GLuint, pname: GLenum, param: [*c]GLint) void {
    return (function_pointers.glGetVertexArrayiv orelse @panic("glGetVertexArrayiv was not bound."))(vaobj, pname, param);
}

pub fn getVertexArrayIndexediv(vaobj: GLuint, index: GLuint, pname: GLenum, param: [*c]GLint) void {
    return (function_pointers.glGetVertexArrayIndexediv orelse @panic("glGetVertexArrayIndexediv was not bound."))(vaobj, index, pname, param);
}

pub fn getVertexArrayIndexed64iv(vaobj: GLuint, index: GLuint, pname: GLenum, param: [*c]GLint64) void {
    return (function_pointers.glGetVertexArrayIndexed64iv orelse @panic("glGetVertexArrayIndexed64iv was not bound."))(vaobj, index, pname, param);
}

pub fn createSamplers(n: GLsizei, samplers: [*c]GLuint) void {
    return (function_pointers.glCreateSamplers orelse @panic("glCreateSamplers was not bound."))(n, samplers);
}

pub fn createProgramPipelines(n: GLsizei, pipelines: [*c]GLuint) void {
    return (function_pointers.glCreateProgramPipelines orelse @panic("glCreateProgramPipelines was not bound."))(n, pipelines);
}

pub fn createQueries(target: GLenum, n: GLsizei, ids: [*c]GLuint) void {
    return (function_pointers.glCreateQueries orelse @panic("glCreateQueries was not bound."))(target, n, ids);
}

pub fn getQueryBufferObjecti64v(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void {
    return (function_pointers.glGetQueryBufferObjecti64v orelse @panic("glGetQueryBufferObjecti64v was not bound."))(id, buffer, pname, offset);
}

pub fn getQueryBufferObjectiv(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void {
    return (function_pointers.glGetQueryBufferObjectiv orelse @panic("glGetQueryBufferObjectiv was not bound."))(id, buffer, pname, offset);
}

pub fn getQueryBufferObjectui64v(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void {
    return (function_pointers.glGetQueryBufferObjectui64v orelse @panic("glGetQueryBufferObjectui64v was not bound."))(id, buffer, pname, offset);
}

pub fn getQueryBufferObjectuiv(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void {
    return (function_pointers.glGetQueryBufferObjectuiv orelse @panic("glGetQueryBufferObjectuiv was not bound."))(id, buffer, pname, offset);
}

pub fn load(load_ctx: anytype, get_proc_address: fn(@TypeOf(load_ctx), [:0]const u8) ?*c_void) !void {
    var success = true;
    if(get_proc_address(load_ctx, "glCreateTransformFeedbacks")) |proc| {
        function_pointers.glCreateTransformFeedbacks = @ptrCast(?function_signatures.glCreateTransformFeedbacks,  proc);
    } else {
        log.emerg("entry point glCreateTransformFeedbacks not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTransformFeedbackBufferBase")) |proc| {
        function_pointers.glTransformFeedbackBufferBase = @ptrCast(?function_signatures.glTransformFeedbackBufferBase,  proc);
    } else {
        log.emerg("entry point glTransformFeedbackBufferBase not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTransformFeedbackBufferRange")) |proc| {
        function_pointers.glTransformFeedbackBufferRange = @ptrCast(?function_signatures.glTransformFeedbackBufferRange,  proc);
    } else {
        log.emerg("entry point glTransformFeedbackBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTransformFeedbackiv")) |proc| {
        function_pointers.glGetTransformFeedbackiv = @ptrCast(?function_signatures.glGetTransformFeedbackiv,  proc);
    } else {
        log.emerg("entry point glGetTransformFeedbackiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTransformFeedbacki_v")) |proc| {
        function_pointers.glGetTransformFeedbacki_v = @ptrCast(?function_signatures.glGetTransformFeedbacki_v,  proc);
    } else {
        log.emerg("entry point glGetTransformFeedbacki_v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTransformFeedbacki64_v")) |proc| {
        function_pointers.glGetTransformFeedbacki64_v = @ptrCast(?function_signatures.glGetTransformFeedbacki64_v,  proc);
    } else {
        log.emerg("entry point glGetTransformFeedbacki64_v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateBuffers")) |proc| {
        function_pointers.glCreateBuffers = @ptrCast(?function_signatures.glCreateBuffers,  proc);
    } else {
        log.emerg("entry point glCreateBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedBufferStorage")) |proc| {
        function_pointers.glNamedBufferStorage = @ptrCast(?function_signatures.glNamedBufferStorage,  proc);
    } else {
        log.emerg("entry point glNamedBufferStorage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedBufferData")) |proc| {
        function_pointers.glNamedBufferData = @ptrCast(?function_signatures.glNamedBufferData,  proc);
    } else {
        log.emerg("entry point glNamedBufferData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedBufferSubData")) |proc| {
        function_pointers.glNamedBufferSubData = @ptrCast(?function_signatures.glNamedBufferSubData,  proc);
    } else {
        log.emerg("entry point glNamedBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyNamedBufferSubData")) |proc| {
        function_pointers.glCopyNamedBufferSubData = @ptrCast(?function_signatures.glCopyNamedBufferSubData,  proc);
    } else {
        log.emerg("entry point glCopyNamedBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedBufferData")) |proc| {
        function_pointers.glClearNamedBufferData = @ptrCast(?function_signatures.glClearNamedBufferData,  proc);
    } else {
        log.emerg("entry point glClearNamedBufferData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedBufferSubData")) |proc| {
        function_pointers.glClearNamedBufferSubData = @ptrCast(?function_signatures.glClearNamedBufferSubData,  proc);
    } else {
        log.emerg("entry point glClearNamedBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMapNamedBuffer")) |proc| {
        function_pointers.glMapNamedBuffer = @ptrCast(?function_signatures.glMapNamedBuffer,  proc);
    } else {
        log.emerg("entry point glMapNamedBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMapNamedBufferRange")) |proc| {
        function_pointers.glMapNamedBufferRange = @ptrCast(?function_signatures.glMapNamedBufferRange,  proc);
    } else {
        log.emerg("entry point glMapNamedBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUnmapNamedBuffer")) |proc| {
        function_pointers.glUnmapNamedBuffer = @ptrCast(?function_signatures.glUnmapNamedBuffer,  proc);
    } else {
        log.emerg("entry point glUnmapNamedBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFlushMappedNamedBufferRange")) |proc| {
        function_pointers.glFlushMappedNamedBufferRange = @ptrCast(?function_signatures.glFlushMappedNamedBufferRange,  proc);
    } else {
        log.emerg("entry point glFlushMappedNamedBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedBufferParameteriv")) |proc| {
        function_pointers.glGetNamedBufferParameteriv = @ptrCast(?function_signatures.glGetNamedBufferParameteriv,  proc);
    } else {
        log.emerg("entry point glGetNamedBufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedBufferParameteri64v")) |proc| {
        function_pointers.glGetNamedBufferParameteri64v = @ptrCast(?function_signatures.glGetNamedBufferParameteri64v,  proc);
    } else {
        log.emerg("entry point glGetNamedBufferParameteri64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedBufferPointerv")) |proc| {
        function_pointers.glGetNamedBufferPointerv = @ptrCast(?function_signatures.glGetNamedBufferPointerv,  proc);
    } else {
        log.emerg("entry point glGetNamedBufferPointerv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedBufferSubData")) |proc| {
        function_pointers.glGetNamedBufferSubData = @ptrCast(?function_signatures.glGetNamedBufferSubData,  proc);
    } else {
        log.emerg("entry point glGetNamedBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateFramebuffers")) |proc| {
        function_pointers.glCreateFramebuffers = @ptrCast(?function_signatures.glCreateFramebuffers,  proc);
    } else {
        log.emerg("entry point glCreateFramebuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferRenderbuffer")) |proc| {
        function_pointers.glNamedFramebufferRenderbuffer = @ptrCast(?function_signatures.glNamedFramebufferRenderbuffer,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferParameteri")) |proc| {
        function_pointers.glNamedFramebufferParameteri = @ptrCast(?function_signatures.glNamedFramebufferParameteri,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferTexture")) |proc| {
        function_pointers.glNamedFramebufferTexture = @ptrCast(?function_signatures.glNamedFramebufferTexture,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferTexture not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferTextureLayer")) |proc| {
        function_pointers.glNamedFramebufferTextureLayer = @ptrCast(?function_signatures.glNamedFramebufferTextureLayer,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferTextureLayer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferDrawBuffer")) |proc| {
        function_pointers.glNamedFramebufferDrawBuffer = @ptrCast(?function_signatures.glNamedFramebufferDrawBuffer,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferDrawBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferDrawBuffers")) |proc| {
        function_pointers.glNamedFramebufferDrawBuffers = @ptrCast(?function_signatures.glNamedFramebufferDrawBuffers,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferDrawBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedFramebufferReadBuffer")) |proc| {
        function_pointers.glNamedFramebufferReadBuffer = @ptrCast(?function_signatures.glNamedFramebufferReadBuffer,  proc);
    } else {
        log.emerg("entry point glNamedFramebufferReadBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glInvalidateNamedFramebufferData")) |proc| {
        function_pointers.glInvalidateNamedFramebufferData = @ptrCast(?function_signatures.glInvalidateNamedFramebufferData,  proc);
    } else {
        log.emerg("entry point glInvalidateNamedFramebufferData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glInvalidateNamedFramebufferSubData")) |proc| {
        function_pointers.glInvalidateNamedFramebufferSubData = @ptrCast(?function_signatures.glInvalidateNamedFramebufferSubData,  proc);
    } else {
        log.emerg("entry point glInvalidateNamedFramebufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedFramebufferiv")) |proc| {
        function_pointers.glClearNamedFramebufferiv = @ptrCast(?function_signatures.glClearNamedFramebufferiv,  proc);
    } else {
        log.emerg("entry point glClearNamedFramebufferiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedFramebufferuiv")) |proc| {
        function_pointers.glClearNamedFramebufferuiv = @ptrCast(?function_signatures.glClearNamedFramebufferuiv,  proc);
    } else {
        log.emerg("entry point glClearNamedFramebufferuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedFramebufferfv")) |proc| {
        function_pointers.glClearNamedFramebufferfv = @ptrCast(?function_signatures.glClearNamedFramebufferfv,  proc);
    } else {
        log.emerg("entry point glClearNamedFramebufferfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearNamedFramebufferfi")) |proc| {
        function_pointers.glClearNamedFramebufferfi = @ptrCast(?function_signatures.glClearNamedFramebufferfi,  proc);
    } else {
        log.emerg("entry point glClearNamedFramebufferfi not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlitNamedFramebuffer")) |proc| {
        function_pointers.glBlitNamedFramebuffer = @ptrCast(?function_signatures.glBlitNamedFramebuffer,  proc);
    } else {
        log.emerg("entry point glBlitNamedFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCheckNamedFramebufferStatus")) |proc| {
        function_pointers.glCheckNamedFramebufferStatus = @ptrCast(?function_signatures.glCheckNamedFramebufferStatus,  proc);
    } else {
        log.emerg("entry point glCheckNamedFramebufferStatus not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedFramebufferParameteriv")) |proc| {
        function_pointers.glGetNamedFramebufferParameteriv = @ptrCast(?function_signatures.glGetNamedFramebufferParameteriv,  proc);
    } else {
        log.emerg("entry point glGetNamedFramebufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedFramebufferAttachmentParameteriv")) |proc| {
        function_pointers.glGetNamedFramebufferAttachmentParameteriv = @ptrCast(?function_signatures.glGetNamedFramebufferAttachmentParameteriv,  proc);
    } else {
        log.emerg("entry point glGetNamedFramebufferAttachmentParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateRenderbuffers")) |proc| {
        function_pointers.glCreateRenderbuffers = @ptrCast(?function_signatures.glCreateRenderbuffers,  proc);
    } else {
        log.emerg("entry point glCreateRenderbuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedRenderbufferStorage")) |proc| {
        function_pointers.glNamedRenderbufferStorage = @ptrCast(?function_signatures.glNamedRenderbufferStorage,  proc);
    } else {
        log.emerg("entry point glNamedRenderbufferStorage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNamedRenderbufferStorageMultisample")) |proc| {
        function_pointers.glNamedRenderbufferStorageMultisample = @ptrCast(?function_signatures.glNamedRenderbufferStorageMultisample,  proc);
    } else {
        log.emerg("entry point glNamedRenderbufferStorageMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetNamedRenderbufferParameteriv")) |proc| {
        function_pointers.glGetNamedRenderbufferParameteriv = @ptrCast(?function_signatures.glGetNamedRenderbufferParameteriv,  proc);
    } else {
        log.emerg("entry point glGetNamedRenderbufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateTextures")) |proc| {
        function_pointers.glCreateTextures = @ptrCast(?function_signatures.glCreateTextures,  proc);
    } else {
        log.emerg("entry point glCreateTextures not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureBuffer")) |proc| {
        function_pointers.glTextureBuffer = @ptrCast(?function_signatures.glTextureBuffer,  proc);
    } else {
        log.emerg("entry point glTextureBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureBufferRange")) |proc| {
        function_pointers.glTextureBufferRange = @ptrCast(?function_signatures.glTextureBufferRange,  proc);
    } else {
        log.emerg("entry point glTextureBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureStorage1D")) |proc| {
        function_pointers.glTextureStorage1D = @ptrCast(?function_signatures.glTextureStorage1D,  proc);
    } else {
        log.emerg("entry point glTextureStorage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureStorage2D")) |proc| {
        function_pointers.glTextureStorage2D = @ptrCast(?function_signatures.glTextureStorage2D,  proc);
    } else {
        log.emerg("entry point glTextureStorage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureStorage3D")) |proc| {
        function_pointers.glTextureStorage3D = @ptrCast(?function_signatures.glTextureStorage3D,  proc);
    } else {
        log.emerg("entry point glTextureStorage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureStorage2DMultisample")) |proc| {
        function_pointers.glTextureStorage2DMultisample = @ptrCast(?function_signatures.glTextureStorage2DMultisample,  proc);
    } else {
        log.emerg("entry point glTextureStorage2DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureStorage3DMultisample")) |proc| {
        function_pointers.glTextureStorage3DMultisample = @ptrCast(?function_signatures.glTextureStorage3DMultisample,  proc);
    } else {
        log.emerg("entry point glTextureStorage3DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureSubImage1D")) |proc| {
        function_pointers.glTextureSubImage1D = @ptrCast(?function_signatures.glTextureSubImage1D,  proc);
    } else {
        log.emerg("entry point glTextureSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureSubImage2D")) |proc| {
        function_pointers.glTextureSubImage2D = @ptrCast(?function_signatures.glTextureSubImage2D,  proc);
    } else {
        log.emerg("entry point glTextureSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureSubImage3D")) |proc| {
        function_pointers.glTextureSubImage3D = @ptrCast(?function_signatures.glTextureSubImage3D,  proc);
    } else {
        log.emerg("entry point glTextureSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTextureSubImage1D")) |proc| {
        function_pointers.glCompressedTextureSubImage1D = @ptrCast(?function_signatures.glCompressedTextureSubImage1D,  proc);
    } else {
        log.emerg("entry point glCompressedTextureSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTextureSubImage2D")) |proc| {
        function_pointers.glCompressedTextureSubImage2D = @ptrCast(?function_signatures.glCompressedTextureSubImage2D,  proc);
    } else {
        log.emerg("entry point glCompressedTextureSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTextureSubImage3D")) |proc| {
        function_pointers.glCompressedTextureSubImage3D = @ptrCast(?function_signatures.glCompressedTextureSubImage3D,  proc);
    } else {
        log.emerg("entry point glCompressedTextureSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTextureSubImage1D")) |proc| {
        function_pointers.glCopyTextureSubImage1D = @ptrCast(?function_signatures.glCopyTextureSubImage1D,  proc);
    } else {
        log.emerg("entry point glCopyTextureSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTextureSubImage2D")) |proc| {
        function_pointers.glCopyTextureSubImage2D = @ptrCast(?function_signatures.glCopyTextureSubImage2D,  proc);
    } else {
        log.emerg("entry point glCopyTextureSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTextureSubImage3D")) |proc| {
        function_pointers.glCopyTextureSubImage3D = @ptrCast(?function_signatures.glCopyTextureSubImage3D,  proc);
    } else {
        log.emerg("entry point glCopyTextureSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameterf")) |proc| {
        function_pointers.glTextureParameterf = @ptrCast(?function_signatures.glTextureParameterf,  proc);
    } else {
        log.emerg("entry point glTextureParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameterfv")) |proc| {
        function_pointers.glTextureParameterfv = @ptrCast(?function_signatures.glTextureParameterfv,  proc);
    } else {
        log.emerg("entry point glTextureParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameteri")) |proc| {
        function_pointers.glTextureParameteri = @ptrCast(?function_signatures.glTextureParameteri,  proc);
    } else {
        log.emerg("entry point glTextureParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameterIiv")) |proc| {
        function_pointers.glTextureParameterIiv = @ptrCast(?function_signatures.glTextureParameterIiv,  proc);
    } else {
        log.emerg("entry point glTextureParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameterIuiv")) |proc| {
        function_pointers.glTextureParameterIuiv = @ptrCast(?function_signatures.glTextureParameterIuiv,  proc);
    } else {
        log.emerg("entry point glTextureParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTextureParameteriv")) |proc| {
        function_pointers.glTextureParameteriv = @ptrCast(?function_signatures.glTextureParameteriv,  proc);
    } else {
        log.emerg("entry point glTextureParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenerateTextureMipmap")) |proc| {
        function_pointers.glGenerateTextureMipmap = @ptrCast(?function_signatures.glGenerateTextureMipmap,  proc);
    } else {
        log.emerg("entry point glGenerateTextureMipmap not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindTextureUnit")) |proc| {
        function_pointers.glBindTextureUnit = @ptrCast(?function_signatures.glBindTextureUnit,  proc);
    } else {
        log.emerg("entry point glBindTextureUnit not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureImage")) |proc| {
        function_pointers.glGetTextureImage = @ptrCast(?function_signatures.glGetTextureImage,  proc);
    } else {
        log.emerg("entry point glGetTextureImage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetCompressedTextureImage")) |proc| {
        function_pointers.glGetCompressedTextureImage = @ptrCast(?function_signatures.glGetCompressedTextureImage,  proc);
    } else {
        log.emerg("entry point glGetCompressedTextureImage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureLevelParameterfv")) |proc| {
        function_pointers.glGetTextureLevelParameterfv = @ptrCast(?function_signatures.glGetTextureLevelParameterfv,  proc);
    } else {
        log.emerg("entry point glGetTextureLevelParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureLevelParameteriv")) |proc| {
        function_pointers.glGetTextureLevelParameteriv = @ptrCast(?function_signatures.glGetTextureLevelParameteriv,  proc);
    } else {
        log.emerg("entry point glGetTextureLevelParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureParameterfv")) |proc| {
        function_pointers.glGetTextureParameterfv = @ptrCast(?function_signatures.glGetTextureParameterfv,  proc);
    } else {
        log.emerg("entry point glGetTextureParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureParameterIiv")) |proc| {
        function_pointers.glGetTextureParameterIiv = @ptrCast(?function_signatures.glGetTextureParameterIiv,  proc);
    } else {
        log.emerg("entry point glGetTextureParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureParameterIuiv")) |proc| {
        function_pointers.glGetTextureParameterIuiv = @ptrCast(?function_signatures.glGetTextureParameterIuiv,  proc);
    } else {
        log.emerg("entry point glGetTextureParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTextureParameteriv")) |proc| {
        function_pointers.glGetTextureParameteriv = @ptrCast(?function_signatures.glGetTextureParameteriv,  proc);
    } else {
        log.emerg("entry point glGetTextureParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateVertexArrays")) |proc| {
        function_pointers.glCreateVertexArrays = @ptrCast(?function_signatures.glCreateVertexArrays,  proc);
    } else {
        log.emerg("entry point glCreateVertexArrays not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDisableVertexArrayAttrib")) |proc| {
        function_pointers.glDisableVertexArrayAttrib = @ptrCast(?function_signatures.glDisableVertexArrayAttrib,  proc);
    } else {
        log.emerg("entry point glDisableVertexArrayAttrib not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEnableVertexArrayAttrib")) |proc| {
        function_pointers.glEnableVertexArrayAttrib = @ptrCast(?function_signatures.glEnableVertexArrayAttrib,  proc);
    } else {
        log.emerg("entry point glEnableVertexArrayAttrib not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayElementBuffer")) |proc| {
        function_pointers.glVertexArrayElementBuffer = @ptrCast(?function_signatures.glVertexArrayElementBuffer,  proc);
    } else {
        log.emerg("entry point glVertexArrayElementBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayVertexBuffer")) |proc| {
        function_pointers.glVertexArrayVertexBuffer = @ptrCast(?function_signatures.glVertexArrayVertexBuffer,  proc);
    } else {
        log.emerg("entry point glVertexArrayVertexBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayVertexBuffers")) |proc| {
        function_pointers.glVertexArrayVertexBuffers = @ptrCast(?function_signatures.glVertexArrayVertexBuffers,  proc);
    } else {
        log.emerg("entry point glVertexArrayVertexBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayAttribBinding")) |proc| {
        function_pointers.glVertexArrayAttribBinding = @ptrCast(?function_signatures.glVertexArrayAttribBinding,  proc);
    } else {
        log.emerg("entry point glVertexArrayAttribBinding not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayAttribFormat")) |proc| {
        function_pointers.glVertexArrayAttribFormat = @ptrCast(?function_signatures.glVertexArrayAttribFormat,  proc);
    } else {
        log.emerg("entry point glVertexArrayAttribFormat not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayAttribIFormat")) |proc| {
        function_pointers.glVertexArrayAttribIFormat = @ptrCast(?function_signatures.glVertexArrayAttribIFormat,  proc);
    } else {
        log.emerg("entry point glVertexArrayAttribIFormat not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayAttribLFormat")) |proc| {
        function_pointers.glVertexArrayAttribLFormat = @ptrCast(?function_signatures.glVertexArrayAttribLFormat,  proc);
    } else {
        log.emerg("entry point glVertexArrayAttribLFormat not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexArrayBindingDivisor")) |proc| {
        function_pointers.glVertexArrayBindingDivisor = @ptrCast(?function_signatures.glVertexArrayBindingDivisor,  proc);
    } else {
        log.emerg("entry point glVertexArrayBindingDivisor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexArrayiv")) |proc| {
        function_pointers.glGetVertexArrayiv = @ptrCast(?function_signatures.glGetVertexArrayiv,  proc);
    } else {
        log.emerg("entry point glGetVertexArrayiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexArrayIndexediv")) |proc| {
        function_pointers.glGetVertexArrayIndexediv = @ptrCast(?function_signatures.glGetVertexArrayIndexediv,  proc);
    } else {
        log.emerg("entry point glGetVertexArrayIndexediv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexArrayIndexed64iv")) |proc| {
        function_pointers.glGetVertexArrayIndexed64iv = @ptrCast(?function_signatures.glGetVertexArrayIndexed64iv,  proc);
    } else {
        log.emerg("entry point glGetVertexArrayIndexed64iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateSamplers")) |proc| {
        function_pointers.glCreateSamplers = @ptrCast(?function_signatures.glCreateSamplers,  proc);
    } else {
        log.emerg("entry point glCreateSamplers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateProgramPipelines")) |proc| {
        function_pointers.glCreateProgramPipelines = @ptrCast(?function_signatures.glCreateProgramPipelines,  proc);
    } else {
        log.emerg("entry point glCreateProgramPipelines not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateQueries")) |proc| {
        function_pointers.glCreateQueries = @ptrCast(?function_signatures.glCreateQueries,  proc);
    } else {
        log.emerg("entry point glCreateQueries not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryBufferObjecti64v")) |proc| {
        function_pointers.glGetQueryBufferObjecti64v = @ptrCast(?function_signatures.glGetQueryBufferObjecti64v,  proc);
    } else {
        log.emerg("entry point glGetQueryBufferObjecti64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryBufferObjectiv")) |proc| {
        function_pointers.glGetQueryBufferObjectiv = @ptrCast(?function_signatures.glGetQueryBufferObjectiv,  proc);
    } else {
        log.emerg("entry point glGetQueryBufferObjectiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryBufferObjectui64v")) |proc| {
        function_pointers.glGetQueryBufferObjectui64v = @ptrCast(?function_signatures.glGetQueryBufferObjectui64v,  proc);
    } else {
        log.emerg("entry point glGetQueryBufferObjectui64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryBufferObjectuiv")) |proc| {
        function_pointers.glGetQueryBufferObjectuiv = @ptrCast(?function_signatures.glGetQueryBufferObjectuiv,  proc);
    } else {
        log.emerg("entry point glGetQueryBufferObjectuiv not found!", .{});
        success = false;
    }
    if(!success)
        return error.EntryPointNotFound;
}
};

// Loader API:
pub fn load(load_ctx: anytype, get_proc_address: fn(@TypeOf(load_ctx), [:0]const u8) ?*c_void) !void {
    var success = true;
    if(get_proc_address(load_ctx, "glCullFace")) |proc| {
        function_pointers.glCullFace = @ptrCast(?function_signatures.glCullFace,  proc);
    } else {
        log.emerg("entry point glCullFace not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFrontFace")) |proc| {
        function_pointers.glFrontFace = @ptrCast(?function_signatures.glFrontFace,  proc);
    } else {
        log.emerg("entry point glFrontFace not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glHint")) |proc| {
        function_pointers.glHint = @ptrCast(?function_signatures.glHint,  proc);
    } else {
        log.emerg("entry point glHint not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glLineWidth")) |proc| {
        function_pointers.glLineWidth = @ptrCast(?function_signatures.glLineWidth,  proc);
    } else {
        log.emerg("entry point glLineWidth not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPointSize")) |proc| {
        function_pointers.glPointSize = @ptrCast(?function_signatures.glPointSize,  proc);
    } else {
        log.emerg("entry point glPointSize not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPolygonMode")) |proc| {
        function_pointers.glPolygonMode = @ptrCast(?function_signatures.glPolygonMode,  proc);
    } else {
        log.emerg("entry point glPolygonMode not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glScissor")) |proc| {
        function_pointers.glScissor = @ptrCast(?function_signatures.glScissor,  proc);
    } else {
        log.emerg("entry point glScissor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameterf")) |proc| {
        function_pointers.glTexParameterf = @ptrCast(?function_signatures.glTexParameterf,  proc);
    } else {
        log.emerg("entry point glTexParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameterfv")) |proc| {
        function_pointers.glTexParameterfv = @ptrCast(?function_signatures.glTexParameterfv,  proc);
    } else {
        log.emerg("entry point glTexParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameteri")) |proc| {
        function_pointers.glTexParameteri = @ptrCast(?function_signatures.glTexParameteri,  proc);
    } else {
        log.emerg("entry point glTexParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameteriv")) |proc| {
        function_pointers.glTexParameteriv = @ptrCast(?function_signatures.glTexParameteriv,  proc);
    } else {
        log.emerg("entry point glTexParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexImage1D")) |proc| {
        function_pointers.glTexImage1D = @ptrCast(?function_signatures.glTexImage1D,  proc);
    } else {
        log.emerg("entry point glTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexImage2D")) |proc| {
        function_pointers.glTexImage2D = @ptrCast(?function_signatures.glTexImage2D,  proc);
    } else {
        log.emerg("entry point glTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawBuffer")) |proc| {
        function_pointers.glDrawBuffer = @ptrCast(?function_signatures.glDrawBuffer,  proc);
    } else {
        log.emerg("entry point glDrawBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClear")) |proc| {
        function_pointers.glClear = @ptrCast(?function_signatures.glClear,  proc);
    } else {
        log.emerg("entry point glClear not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearColor")) |proc| {
        function_pointers.glClearColor = @ptrCast(?function_signatures.glClearColor,  proc);
    } else {
        log.emerg("entry point glClearColor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearStencil")) |proc| {
        function_pointers.glClearStencil = @ptrCast(?function_signatures.glClearStencil,  proc);
    } else {
        log.emerg("entry point glClearStencil not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearDepth")) |proc| {
        function_pointers.glClearDepth = @ptrCast(?function_signatures.glClearDepth,  proc);
    } else {
        log.emerg("entry point glClearDepth not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilMask")) |proc| {
        function_pointers.glStencilMask = @ptrCast(?function_signatures.glStencilMask,  proc);
    } else {
        log.emerg("entry point glStencilMask not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorMask")) |proc| {
        function_pointers.glColorMask = @ptrCast(?function_signatures.glColorMask,  proc);
    } else {
        log.emerg("entry point glColorMask not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDepthMask")) |proc| {
        function_pointers.glDepthMask = @ptrCast(?function_signatures.glDepthMask,  proc);
    } else {
        log.emerg("entry point glDepthMask not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDisable")) |proc| {
        function_pointers.glDisable = @ptrCast(?function_signatures.glDisable,  proc);
    } else {
        log.emerg("entry point glDisable not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEnable")) |proc| {
        function_pointers.glEnable = @ptrCast(?function_signatures.glEnable,  proc);
    } else {
        log.emerg("entry point glEnable not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFinish")) |proc| {
        function_pointers.glFinish = @ptrCast(?function_signatures.glFinish,  proc);
    } else {
        log.emerg("entry point glFinish not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFlush")) |proc| {
        function_pointers.glFlush = @ptrCast(?function_signatures.glFlush,  proc);
    } else {
        log.emerg("entry point glFlush not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlendFunc")) |proc| {
        function_pointers.glBlendFunc = @ptrCast(?function_signatures.glBlendFunc,  proc);
    } else {
        log.emerg("entry point glBlendFunc not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glLogicOp")) |proc| {
        function_pointers.glLogicOp = @ptrCast(?function_signatures.glLogicOp,  proc);
    } else {
        log.emerg("entry point glLogicOp not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilFunc")) |proc| {
        function_pointers.glStencilFunc = @ptrCast(?function_signatures.glStencilFunc,  proc);
    } else {
        log.emerg("entry point glStencilFunc not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilOp")) |proc| {
        function_pointers.glStencilOp = @ptrCast(?function_signatures.glStencilOp,  proc);
    } else {
        log.emerg("entry point glStencilOp not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDepthFunc")) |proc| {
        function_pointers.glDepthFunc = @ptrCast(?function_signatures.glDepthFunc,  proc);
    } else {
        log.emerg("entry point glDepthFunc not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPixelStoref")) |proc| {
        function_pointers.glPixelStoref = @ptrCast(?function_signatures.glPixelStoref,  proc);
    } else {
        log.emerg("entry point glPixelStoref not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPixelStorei")) |proc| {
        function_pointers.glPixelStorei = @ptrCast(?function_signatures.glPixelStorei,  proc);
    } else {
        log.emerg("entry point glPixelStorei not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glReadBuffer")) |proc| {
        function_pointers.glReadBuffer = @ptrCast(?function_signatures.glReadBuffer,  proc);
    } else {
        log.emerg("entry point glReadBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glReadPixels")) |proc| {
        function_pointers.glReadPixels = @ptrCast(?function_signatures.glReadPixels,  proc);
    } else {
        log.emerg("entry point glReadPixels not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBooleanv")) |proc| {
        function_pointers.glGetBooleanv = @ptrCast(?function_signatures.glGetBooleanv,  proc);
    } else {
        log.emerg("entry point glGetBooleanv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetDoublev")) |proc| {
        function_pointers.glGetDoublev = @ptrCast(?function_signatures.glGetDoublev,  proc);
    } else {
        log.emerg("entry point glGetDoublev not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetError")) |proc| {
        function_pointers.glGetError = @ptrCast(?function_signatures.glGetError,  proc);
    } else {
        log.emerg("entry point glGetError not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetFloatv")) |proc| {
        function_pointers.glGetFloatv = @ptrCast(?function_signatures.glGetFloatv,  proc);
    } else {
        log.emerg("entry point glGetFloatv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetIntegerv")) |proc| {
        function_pointers.glGetIntegerv = @ptrCast(?function_signatures.glGetIntegerv,  proc);
    } else {
        log.emerg("entry point glGetIntegerv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetString")) |proc| {
        function_pointers.glGetString = @ptrCast(?function_signatures.glGetString,  proc);
    } else {
        log.emerg("entry point glGetString not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexImage")) |proc| {
        function_pointers.glGetTexImage = @ptrCast(?function_signatures.glGetTexImage,  proc);
    } else {
        log.emerg("entry point glGetTexImage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexParameterfv")) |proc| {
        function_pointers.glGetTexParameterfv = @ptrCast(?function_signatures.glGetTexParameterfv,  proc);
    } else {
        log.emerg("entry point glGetTexParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexParameteriv")) |proc| {
        function_pointers.glGetTexParameteriv = @ptrCast(?function_signatures.glGetTexParameteriv,  proc);
    } else {
        log.emerg("entry point glGetTexParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexLevelParameterfv")) |proc| {
        function_pointers.glGetTexLevelParameterfv = @ptrCast(?function_signatures.glGetTexLevelParameterfv,  proc);
    } else {
        log.emerg("entry point glGetTexLevelParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexLevelParameteriv")) |proc| {
        function_pointers.glGetTexLevelParameteriv = @ptrCast(?function_signatures.glGetTexLevelParameteriv,  proc);
    } else {
        log.emerg("entry point glGetTexLevelParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsEnabled")) |proc| {
        function_pointers.glIsEnabled = @ptrCast(?function_signatures.glIsEnabled,  proc);
    } else {
        log.emerg("entry point glIsEnabled not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDepthRange")) |proc| {
        function_pointers.glDepthRange = @ptrCast(?function_signatures.glDepthRange,  proc);
    } else {
        log.emerg("entry point glDepthRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glViewport")) |proc| {
        function_pointers.glViewport = @ptrCast(?function_signatures.glViewport,  proc);
    } else {
        log.emerg("entry point glViewport not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawArrays")) |proc| {
        function_pointers.glDrawArrays = @ptrCast(?function_signatures.glDrawArrays,  proc);
    } else {
        log.emerg("entry point glDrawArrays not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawElements")) |proc| {
        function_pointers.glDrawElements = @ptrCast(?function_signatures.glDrawElements,  proc);
    } else {
        log.emerg("entry point glDrawElements not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPolygonOffset")) |proc| {
        function_pointers.glPolygonOffset = @ptrCast(?function_signatures.glPolygonOffset,  proc);
    } else {
        log.emerg("entry point glPolygonOffset not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTexImage1D")) |proc| {
        function_pointers.glCopyTexImage1D = @ptrCast(?function_signatures.glCopyTexImage1D,  proc);
    } else {
        log.emerg("entry point glCopyTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTexImage2D")) |proc| {
        function_pointers.glCopyTexImage2D = @ptrCast(?function_signatures.glCopyTexImage2D,  proc);
    } else {
        log.emerg("entry point glCopyTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTexSubImage1D")) |proc| {
        function_pointers.glCopyTexSubImage1D = @ptrCast(?function_signatures.glCopyTexSubImage1D,  proc);
    } else {
        log.emerg("entry point glCopyTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTexSubImage2D")) |proc| {
        function_pointers.glCopyTexSubImage2D = @ptrCast(?function_signatures.glCopyTexSubImage2D,  proc);
    } else {
        log.emerg("entry point glCopyTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexSubImage1D")) |proc| {
        function_pointers.glTexSubImage1D = @ptrCast(?function_signatures.glTexSubImage1D,  proc);
    } else {
        log.emerg("entry point glTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexSubImage2D")) |proc| {
        function_pointers.glTexSubImage2D = @ptrCast(?function_signatures.glTexSubImage2D,  proc);
    } else {
        log.emerg("entry point glTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindTexture")) |proc| {
        function_pointers.glBindTexture = @ptrCast(?function_signatures.glBindTexture,  proc);
    } else {
        log.emerg("entry point glBindTexture not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteTextures")) |proc| {
        function_pointers.glDeleteTextures = @ptrCast(?function_signatures.glDeleteTextures,  proc);
    } else {
        log.emerg("entry point glDeleteTextures not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenTextures")) |proc| {
        function_pointers.glGenTextures = @ptrCast(?function_signatures.glGenTextures,  proc);
    } else {
        log.emerg("entry point glGenTextures not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsTexture")) |proc| {
        function_pointers.glIsTexture = @ptrCast(?function_signatures.glIsTexture,  proc);
    } else {
        log.emerg("entry point glIsTexture not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawRangeElements")) |proc| {
        function_pointers.glDrawRangeElements = @ptrCast(?function_signatures.glDrawRangeElements,  proc);
    } else {
        log.emerg("entry point glDrawRangeElements not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexImage3D")) |proc| {
        function_pointers.glTexImage3D = @ptrCast(?function_signatures.glTexImage3D,  proc);
    } else {
        log.emerg("entry point glTexImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexSubImage3D")) |proc| {
        function_pointers.glTexSubImage3D = @ptrCast(?function_signatures.glTexSubImage3D,  proc);
    } else {
        log.emerg("entry point glTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyTexSubImage3D")) |proc| {
        function_pointers.glCopyTexSubImage3D = @ptrCast(?function_signatures.glCopyTexSubImage3D,  proc);
    } else {
        log.emerg("entry point glCopyTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSecondaryColorP3uiv")) |proc| {
        function_pointers.glSecondaryColorP3uiv = @ptrCast(?function_signatures.glSecondaryColorP3uiv,  proc);
    } else {
        log.emerg("entry point glSecondaryColorP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSecondaryColorP3ui")) |proc| {
        function_pointers.glSecondaryColorP3ui = @ptrCast(?function_signatures.glSecondaryColorP3ui,  proc);
    } else {
        log.emerg("entry point glSecondaryColorP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorP4uiv")) |proc| {
        function_pointers.glColorP4uiv = @ptrCast(?function_signatures.glColorP4uiv,  proc);
    } else {
        log.emerg("entry point glColorP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorP4ui")) |proc| {
        function_pointers.glColorP4ui = @ptrCast(?function_signatures.glColorP4ui,  proc);
    } else {
        log.emerg("entry point glColorP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorP3uiv")) |proc| {
        function_pointers.glColorP3uiv = @ptrCast(?function_signatures.glColorP3uiv,  proc);
    } else {
        log.emerg("entry point glColorP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorP3ui")) |proc| {
        function_pointers.glColorP3ui = @ptrCast(?function_signatures.glColorP3ui,  proc);
    } else {
        log.emerg("entry point glColorP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNormalP3uiv")) |proc| {
        function_pointers.glNormalP3uiv = @ptrCast(?function_signatures.glNormalP3uiv,  proc);
    } else {
        log.emerg("entry point glNormalP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glNormalP3ui")) |proc| {
        function_pointers.glNormalP3ui = @ptrCast(?function_signatures.glNormalP3ui,  proc);
    } else {
        log.emerg("entry point glNormalP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP4uiv")) |proc| {
        function_pointers.glMultiTexCoordP4uiv = @ptrCast(?function_signatures.glMultiTexCoordP4uiv,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP4ui")) |proc| {
        function_pointers.glMultiTexCoordP4ui = @ptrCast(?function_signatures.glMultiTexCoordP4ui,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP3uiv")) |proc| {
        function_pointers.glMultiTexCoordP3uiv = @ptrCast(?function_signatures.glMultiTexCoordP3uiv,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP3ui")) |proc| {
        function_pointers.glMultiTexCoordP3ui = @ptrCast(?function_signatures.glMultiTexCoordP3ui,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP2uiv")) |proc| {
        function_pointers.glMultiTexCoordP2uiv = @ptrCast(?function_signatures.glMultiTexCoordP2uiv,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP2ui")) |proc| {
        function_pointers.glMultiTexCoordP2ui = @ptrCast(?function_signatures.glMultiTexCoordP2ui,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP1uiv")) |proc| {
        function_pointers.glMultiTexCoordP1uiv = @ptrCast(?function_signatures.glMultiTexCoordP1uiv,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiTexCoordP1ui")) |proc| {
        function_pointers.glMultiTexCoordP1ui = @ptrCast(?function_signatures.glMultiTexCoordP1ui,  proc);
    } else {
        log.emerg("entry point glMultiTexCoordP1ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP4uiv")) |proc| {
        function_pointers.glTexCoordP4uiv = @ptrCast(?function_signatures.glTexCoordP4uiv,  proc);
    } else {
        log.emerg("entry point glTexCoordP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP4ui")) |proc| {
        function_pointers.glTexCoordP4ui = @ptrCast(?function_signatures.glTexCoordP4ui,  proc);
    } else {
        log.emerg("entry point glTexCoordP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP3uiv")) |proc| {
        function_pointers.glTexCoordP3uiv = @ptrCast(?function_signatures.glTexCoordP3uiv,  proc);
    } else {
        log.emerg("entry point glTexCoordP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP3ui")) |proc| {
        function_pointers.glTexCoordP3ui = @ptrCast(?function_signatures.glTexCoordP3ui,  proc);
    } else {
        log.emerg("entry point glTexCoordP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glActiveTexture")) |proc| {
        function_pointers.glActiveTexture = @ptrCast(?function_signatures.glActiveTexture,  proc);
    } else {
        log.emerg("entry point glActiveTexture not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSampleCoverage")) |proc| {
        function_pointers.glSampleCoverage = @ptrCast(?function_signatures.glSampleCoverage,  proc);
    } else {
        log.emerg("entry point glSampleCoverage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexImage3D")) |proc| {
        function_pointers.glCompressedTexImage3D = @ptrCast(?function_signatures.glCompressedTexImage3D,  proc);
    } else {
        log.emerg("entry point glCompressedTexImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexImage2D")) |proc| {
        function_pointers.glCompressedTexImage2D = @ptrCast(?function_signatures.glCompressedTexImage2D,  proc);
    } else {
        log.emerg("entry point glCompressedTexImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexImage1D")) |proc| {
        function_pointers.glCompressedTexImage1D = @ptrCast(?function_signatures.glCompressedTexImage1D,  proc);
    } else {
        log.emerg("entry point glCompressedTexImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexSubImage3D")) |proc| {
        function_pointers.glCompressedTexSubImage3D = @ptrCast(?function_signatures.glCompressedTexSubImage3D,  proc);
    } else {
        log.emerg("entry point glCompressedTexSubImage3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexSubImage2D")) |proc| {
        function_pointers.glCompressedTexSubImage2D = @ptrCast(?function_signatures.glCompressedTexSubImage2D,  proc);
    } else {
        log.emerg("entry point glCompressedTexSubImage2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompressedTexSubImage1D")) |proc| {
        function_pointers.glCompressedTexSubImage1D = @ptrCast(?function_signatures.glCompressedTexSubImage1D,  proc);
    } else {
        log.emerg("entry point glCompressedTexSubImage1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetCompressedTexImage")) |proc| {
        function_pointers.glGetCompressedTexImage = @ptrCast(?function_signatures.glGetCompressedTexImage,  proc);
    } else {
        log.emerg("entry point glGetCompressedTexImage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP2uiv")) |proc| {
        function_pointers.glTexCoordP2uiv = @ptrCast(?function_signatures.glTexCoordP2uiv,  proc);
    } else {
        log.emerg("entry point glTexCoordP2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP2ui")) |proc| {
        function_pointers.glTexCoordP2ui = @ptrCast(?function_signatures.glTexCoordP2ui,  proc);
    } else {
        log.emerg("entry point glTexCoordP2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP1uiv")) |proc| {
        function_pointers.glTexCoordP1uiv = @ptrCast(?function_signatures.glTexCoordP1uiv,  proc);
    } else {
        log.emerg("entry point glTexCoordP1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexCoordP1ui")) |proc| {
        function_pointers.glTexCoordP1ui = @ptrCast(?function_signatures.glTexCoordP1ui,  proc);
    } else {
        log.emerg("entry point glTexCoordP1ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP4uiv")) |proc| {
        function_pointers.glVertexP4uiv = @ptrCast(?function_signatures.glVertexP4uiv,  proc);
    } else {
        log.emerg("entry point glVertexP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP4ui")) |proc| {
        function_pointers.glVertexP4ui = @ptrCast(?function_signatures.glVertexP4ui,  proc);
    } else {
        log.emerg("entry point glVertexP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP3uiv")) |proc| {
        function_pointers.glVertexP3uiv = @ptrCast(?function_signatures.glVertexP3uiv,  proc);
    } else {
        log.emerg("entry point glVertexP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP3ui")) |proc| {
        function_pointers.glVertexP3ui = @ptrCast(?function_signatures.glVertexP3ui,  proc);
    } else {
        log.emerg("entry point glVertexP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP2uiv")) |proc| {
        function_pointers.glVertexP2uiv = @ptrCast(?function_signatures.glVertexP2uiv,  proc);
    } else {
        log.emerg("entry point glVertexP2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexP2ui")) |proc| {
        function_pointers.glVertexP2ui = @ptrCast(?function_signatures.glVertexP2ui,  proc);
    } else {
        log.emerg("entry point glVertexP2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP4uiv")) |proc| {
        function_pointers.glVertexAttribP4uiv = @ptrCast(?function_signatures.glVertexAttribP4uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribP4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP4ui")) |proc| {
        function_pointers.glVertexAttribP4ui = @ptrCast(?function_signatures.glVertexAttribP4ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribP4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP3uiv")) |proc| {
        function_pointers.glVertexAttribP3uiv = @ptrCast(?function_signatures.glVertexAttribP3uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribP3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP3ui")) |proc| {
        function_pointers.glVertexAttribP3ui = @ptrCast(?function_signatures.glVertexAttribP3ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribP3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP2uiv")) |proc| {
        function_pointers.glVertexAttribP2uiv = @ptrCast(?function_signatures.glVertexAttribP2uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribP2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP2ui")) |proc| {
        function_pointers.glVertexAttribP2ui = @ptrCast(?function_signatures.glVertexAttribP2ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribP2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP1uiv")) |proc| {
        function_pointers.glVertexAttribP1uiv = @ptrCast(?function_signatures.glVertexAttribP1uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribP1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribP1ui")) |proc| {
        function_pointers.glVertexAttribP1ui = @ptrCast(?function_signatures.glVertexAttribP1ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribP1ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribDivisor")) |proc| {
        function_pointers.glVertexAttribDivisor = @ptrCast(?function_signatures.glVertexAttribDivisor,  proc);
    } else {
        log.emerg("entry point glVertexAttribDivisor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryObjectui64v")) |proc| {
        function_pointers.glGetQueryObjectui64v = @ptrCast(?function_signatures.glGetQueryObjectui64v,  proc);
    } else {
        log.emerg("entry point glGetQueryObjectui64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryObjecti64v")) |proc| {
        function_pointers.glGetQueryObjecti64v = @ptrCast(?function_signatures.glGetQueryObjecti64v,  proc);
    } else {
        log.emerg("entry point glGetQueryObjecti64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glQueryCounter")) |proc| {
        function_pointers.glQueryCounter = @ptrCast(?function_signatures.glQueryCounter,  proc);
    } else {
        log.emerg("entry point glQueryCounter not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetSamplerParameterIuiv")) |proc| {
        function_pointers.glGetSamplerParameterIuiv = @ptrCast(?function_signatures.glGetSamplerParameterIuiv,  proc);
    } else {
        log.emerg("entry point glGetSamplerParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetSamplerParameterfv")) |proc| {
        function_pointers.glGetSamplerParameterfv = @ptrCast(?function_signatures.glGetSamplerParameterfv,  proc);
    } else {
        log.emerg("entry point glGetSamplerParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetSamplerParameterIiv")) |proc| {
        function_pointers.glGetSamplerParameterIiv = @ptrCast(?function_signatures.glGetSamplerParameterIiv,  proc);
    } else {
        log.emerg("entry point glGetSamplerParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetSamplerParameteriv")) |proc| {
        function_pointers.glGetSamplerParameteriv = @ptrCast(?function_signatures.glGetSamplerParameteriv,  proc);
    } else {
        log.emerg("entry point glGetSamplerParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameterIuiv")) |proc| {
        function_pointers.glSamplerParameterIuiv = @ptrCast(?function_signatures.glSamplerParameterIuiv,  proc);
    } else {
        log.emerg("entry point glSamplerParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameterIiv")) |proc| {
        function_pointers.glSamplerParameterIiv = @ptrCast(?function_signatures.glSamplerParameterIiv,  proc);
    } else {
        log.emerg("entry point glSamplerParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameterfv")) |proc| {
        function_pointers.glSamplerParameterfv = @ptrCast(?function_signatures.glSamplerParameterfv,  proc);
    } else {
        log.emerg("entry point glSamplerParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameterf")) |proc| {
        function_pointers.glSamplerParameterf = @ptrCast(?function_signatures.glSamplerParameterf,  proc);
    } else {
        log.emerg("entry point glSamplerParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameteriv")) |proc| {
        function_pointers.glSamplerParameteriv = @ptrCast(?function_signatures.glSamplerParameteriv,  proc);
    } else {
        log.emerg("entry point glSamplerParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSamplerParameteri")) |proc| {
        function_pointers.glSamplerParameteri = @ptrCast(?function_signatures.glSamplerParameteri,  proc);
    } else {
        log.emerg("entry point glSamplerParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindSampler")) |proc| {
        function_pointers.glBindSampler = @ptrCast(?function_signatures.glBindSampler,  proc);
    } else {
        log.emerg("entry point glBindSampler not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsSampler")) |proc| {
        function_pointers.glIsSampler = @ptrCast(?function_signatures.glIsSampler,  proc);
    } else {
        log.emerg("entry point glIsSampler not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteSamplers")) |proc| {
        function_pointers.glDeleteSamplers = @ptrCast(?function_signatures.glDeleteSamplers,  proc);
    } else {
        log.emerg("entry point glDeleteSamplers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenSamplers")) |proc| {
        function_pointers.glGenSamplers = @ptrCast(?function_signatures.glGenSamplers,  proc);
    } else {
        log.emerg("entry point glGenSamplers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetFragDataIndex")) |proc| {
        function_pointers.glGetFragDataIndex = @ptrCast(?function_signatures.glGetFragDataIndex,  proc);
    } else {
        log.emerg("entry point glGetFragDataIndex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindFragDataLocationIndexed")) |proc| {
        function_pointers.glBindFragDataLocationIndexed = @ptrCast(?function_signatures.glBindFragDataLocationIndexed,  proc);
    } else {
        log.emerg("entry point glBindFragDataLocationIndexed not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glSampleMaski")) |proc| {
        function_pointers.glSampleMaski = @ptrCast(?function_signatures.glSampleMaski,  proc);
    } else {
        log.emerg("entry point glSampleMaski not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetMultisamplefv")) |proc| {
        function_pointers.glGetMultisamplefv = @ptrCast(?function_signatures.glGetMultisamplefv,  proc);
    } else {
        log.emerg("entry point glGetMultisamplefv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexImage3DMultisample")) |proc| {
        function_pointers.glTexImage3DMultisample = @ptrCast(?function_signatures.glTexImage3DMultisample,  proc);
    } else {
        log.emerg("entry point glTexImage3DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexImage2DMultisample")) |proc| {
        function_pointers.glTexImage2DMultisample = @ptrCast(?function_signatures.glTexImage2DMultisample,  proc);
    } else {
        log.emerg("entry point glTexImage2DMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferTexture")) |proc| {
        function_pointers.glFramebufferTexture = @ptrCast(?function_signatures.glFramebufferTexture,  proc);
    } else {
        log.emerg("entry point glFramebufferTexture not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBufferParameteri64v")) |proc| {
        function_pointers.glGetBufferParameteri64v = @ptrCast(?function_signatures.glGetBufferParameteri64v,  proc);
    } else {
        log.emerg("entry point glGetBufferParameteri64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlendFuncSeparate")) |proc| {
        function_pointers.glBlendFuncSeparate = @ptrCast(?function_signatures.glBlendFuncSeparate,  proc);
    } else {
        log.emerg("entry point glBlendFuncSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiDrawArrays")) |proc| {
        function_pointers.glMultiDrawArrays = @ptrCast(?function_signatures.glMultiDrawArrays,  proc);
    } else {
        log.emerg("entry point glMultiDrawArrays not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiDrawElements")) |proc| {
        function_pointers.glMultiDrawElements = @ptrCast(?function_signatures.glMultiDrawElements,  proc);
    } else {
        log.emerg("entry point glMultiDrawElements not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPointParameterf")) |proc| {
        function_pointers.glPointParameterf = @ptrCast(?function_signatures.glPointParameterf,  proc);
    } else {
        log.emerg("entry point glPointParameterf not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPointParameterfv")) |proc| {
        function_pointers.glPointParameterfv = @ptrCast(?function_signatures.glPointParameterfv,  proc);
    } else {
        log.emerg("entry point glPointParameterfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPointParameteri")) |proc| {
        function_pointers.glPointParameteri = @ptrCast(?function_signatures.glPointParameteri,  proc);
    } else {
        log.emerg("entry point glPointParameteri not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPointParameteriv")) |proc| {
        function_pointers.glPointParameteriv = @ptrCast(?function_signatures.glPointParameteriv,  proc);
    } else {
        log.emerg("entry point glPointParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetInteger64i_v")) |proc| {
        function_pointers.glGetInteger64i_v = @ptrCast(?function_signatures.glGetInteger64i_v,  proc);
    } else {
        log.emerg("entry point glGetInteger64i_v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetSynciv")) |proc| {
        function_pointers.glGetSynciv = @ptrCast(?function_signatures.glGetSynciv,  proc);
    } else {
        log.emerg("entry point glGetSynciv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetInteger64v")) |proc| {
        function_pointers.glGetInteger64v = @ptrCast(?function_signatures.glGetInteger64v,  proc);
    } else {
        log.emerg("entry point glGetInteger64v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glWaitSync")) |proc| {
        function_pointers.glWaitSync = @ptrCast(?function_signatures.glWaitSync,  proc);
    } else {
        log.emerg("entry point glWaitSync not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClientWaitSync")) |proc| {
        function_pointers.glClientWaitSync = @ptrCast(?function_signatures.glClientWaitSync,  proc);
    } else {
        log.emerg("entry point glClientWaitSync not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteSync")) |proc| {
        function_pointers.glDeleteSync = @ptrCast(?function_signatures.glDeleteSync,  proc);
    } else {
        log.emerg("entry point glDeleteSync not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsSync")) |proc| {
        function_pointers.glIsSync = @ptrCast(?function_signatures.glIsSync,  proc);
    } else {
        log.emerg("entry point glIsSync not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFenceSync")) |proc| {
        function_pointers.glFenceSync = @ptrCast(?function_signatures.glFenceSync,  proc);
    } else {
        log.emerg("entry point glFenceSync not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlendColor")) |proc| {
        function_pointers.glBlendColor = @ptrCast(?function_signatures.glBlendColor,  proc);
    } else {
        log.emerg("entry point glBlendColor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlendEquation")) |proc| {
        function_pointers.glBlendEquation = @ptrCast(?function_signatures.glBlendEquation,  proc);
    } else {
        log.emerg("entry point glBlendEquation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glProvokingVertex")) |proc| {
        function_pointers.glProvokingVertex = @ptrCast(?function_signatures.glProvokingVertex,  proc);
    } else {
        log.emerg("entry point glProvokingVertex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMultiDrawElementsBaseVertex")) |proc| {
        function_pointers.glMultiDrawElementsBaseVertex = @ptrCast(?function_signatures.glMultiDrawElementsBaseVertex,  proc);
    } else {
        log.emerg("entry point glMultiDrawElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawElementsInstancedBaseVertex")) |proc| {
        function_pointers.glDrawElementsInstancedBaseVertex = @ptrCast(?function_signatures.glDrawElementsInstancedBaseVertex,  proc);
    } else {
        log.emerg("entry point glDrawElementsInstancedBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawRangeElementsBaseVertex")) |proc| {
        function_pointers.glDrawRangeElementsBaseVertex = @ptrCast(?function_signatures.glDrawRangeElementsBaseVertex,  proc);
    } else {
        log.emerg("entry point glDrawRangeElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawElementsBaseVertex")) |proc| {
        function_pointers.glDrawElementsBaseVertex = @ptrCast(?function_signatures.glDrawElementsBaseVertex,  proc);
    } else {
        log.emerg("entry point glDrawElementsBaseVertex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenQueries")) |proc| {
        function_pointers.glGenQueries = @ptrCast(?function_signatures.glGenQueries,  proc);
    } else {
        log.emerg("entry point glGenQueries not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteQueries")) |proc| {
        function_pointers.glDeleteQueries = @ptrCast(?function_signatures.glDeleteQueries,  proc);
    } else {
        log.emerg("entry point glDeleteQueries not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsQuery")) |proc| {
        function_pointers.glIsQuery = @ptrCast(?function_signatures.glIsQuery,  proc);
    } else {
        log.emerg("entry point glIsQuery not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBeginQuery")) |proc| {
        function_pointers.glBeginQuery = @ptrCast(?function_signatures.glBeginQuery,  proc);
    } else {
        log.emerg("entry point glBeginQuery not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEndQuery")) |proc| {
        function_pointers.glEndQuery = @ptrCast(?function_signatures.glEndQuery,  proc);
    } else {
        log.emerg("entry point glEndQuery not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryiv")) |proc| {
        function_pointers.glGetQueryiv = @ptrCast(?function_signatures.glGetQueryiv,  proc);
    } else {
        log.emerg("entry point glGetQueryiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryObjectiv")) |proc| {
        function_pointers.glGetQueryObjectiv = @ptrCast(?function_signatures.glGetQueryObjectiv,  proc);
    } else {
        log.emerg("entry point glGetQueryObjectiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetQueryObjectuiv")) |proc| {
        function_pointers.glGetQueryObjectuiv = @ptrCast(?function_signatures.glGetQueryObjectuiv,  proc);
    } else {
        log.emerg("entry point glGetQueryObjectuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindBuffer")) |proc| {
        function_pointers.glBindBuffer = @ptrCast(?function_signatures.glBindBuffer,  proc);
    } else {
        log.emerg("entry point glBindBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteBuffers")) |proc| {
        function_pointers.glDeleteBuffers = @ptrCast(?function_signatures.glDeleteBuffers,  proc);
    } else {
        log.emerg("entry point glDeleteBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenBuffers")) |proc| {
        function_pointers.glGenBuffers = @ptrCast(?function_signatures.glGenBuffers,  proc);
    } else {
        log.emerg("entry point glGenBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsBuffer")) |proc| {
        function_pointers.glIsBuffer = @ptrCast(?function_signatures.glIsBuffer,  proc);
    } else {
        log.emerg("entry point glIsBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBufferData")) |proc| {
        function_pointers.glBufferData = @ptrCast(?function_signatures.glBufferData,  proc);
    } else {
        log.emerg("entry point glBufferData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBufferSubData")) |proc| {
        function_pointers.glBufferSubData = @ptrCast(?function_signatures.glBufferSubData,  proc);
    } else {
        log.emerg("entry point glBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBufferSubData")) |proc| {
        function_pointers.glGetBufferSubData = @ptrCast(?function_signatures.glGetBufferSubData,  proc);
    } else {
        log.emerg("entry point glGetBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMapBuffer")) |proc| {
        function_pointers.glMapBuffer = @ptrCast(?function_signatures.glMapBuffer,  proc);
    } else {
        log.emerg("entry point glMapBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUnmapBuffer")) |proc| {
        function_pointers.glUnmapBuffer = @ptrCast(?function_signatures.glUnmapBuffer,  proc);
    } else {
        log.emerg("entry point glUnmapBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBufferParameteriv")) |proc| {
        function_pointers.glGetBufferParameteriv = @ptrCast(?function_signatures.glGetBufferParameteriv,  proc);
    } else {
        log.emerg("entry point glGetBufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBufferPointerv")) |proc| {
        function_pointers.glGetBufferPointerv = @ptrCast(?function_signatures.glGetBufferPointerv,  proc);
    } else {
        log.emerg("entry point glGetBufferPointerv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlendEquationSeparate")) |proc| {
        function_pointers.glBlendEquationSeparate = @ptrCast(?function_signatures.glBlendEquationSeparate,  proc);
    } else {
        log.emerg("entry point glBlendEquationSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawBuffers")) |proc| {
        function_pointers.glDrawBuffers = @ptrCast(?function_signatures.glDrawBuffers,  proc);
    } else {
        log.emerg("entry point glDrawBuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilOpSeparate")) |proc| {
        function_pointers.glStencilOpSeparate = @ptrCast(?function_signatures.glStencilOpSeparate,  proc);
    } else {
        log.emerg("entry point glStencilOpSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilFuncSeparate")) |proc| {
        function_pointers.glStencilFuncSeparate = @ptrCast(?function_signatures.glStencilFuncSeparate,  proc);
    } else {
        log.emerg("entry point glStencilFuncSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glStencilMaskSeparate")) |proc| {
        function_pointers.glStencilMaskSeparate = @ptrCast(?function_signatures.glStencilMaskSeparate,  proc);
    } else {
        log.emerg("entry point glStencilMaskSeparate not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glAttachShader")) |proc| {
        function_pointers.glAttachShader = @ptrCast(?function_signatures.glAttachShader,  proc);
    } else {
        log.emerg("entry point glAttachShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindAttribLocation")) |proc| {
        function_pointers.glBindAttribLocation = @ptrCast(?function_signatures.glBindAttribLocation,  proc);
    } else {
        log.emerg("entry point glBindAttribLocation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCompileShader")) |proc| {
        function_pointers.glCompileShader = @ptrCast(?function_signatures.glCompileShader,  proc);
    } else {
        log.emerg("entry point glCompileShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateProgram")) |proc| {
        function_pointers.glCreateProgram = @ptrCast(?function_signatures.glCreateProgram,  proc);
    } else {
        log.emerg("entry point glCreateProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCreateShader")) |proc| {
        function_pointers.glCreateShader = @ptrCast(?function_signatures.glCreateShader,  proc);
    } else {
        log.emerg("entry point glCreateShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteProgram")) |proc| {
        function_pointers.glDeleteProgram = @ptrCast(?function_signatures.glDeleteProgram,  proc);
    } else {
        log.emerg("entry point glDeleteProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteShader")) |proc| {
        function_pointers.glDeleteShader = @ptrCast(?function_signatures.glDeleteShader,  proc);
    } else {
        log.emerg("entry point glDeleteShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDetachShader")) |proc| {
        function_pointers.glDetachShader = @ptrCast(?function_signatures.glDetachShader,  proc);
    } else {
        log.emerg("entry point glDetachShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDisableVertexAttribArray")) |proc| {
        function_pointers.glDisableVertexAttribArray = @ptrCast(?function_signatures.glDisableVertexAttribArray,  proc);
    } else {
        log.emerg("entry point glDisableVertexAttribArray not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEnableVertexAttribArray")) |proc| {
        function_pointers.glEnableVertexAttribArray = @ptrCast(?function_signatures.glEnableVertexAttribArray,  proc);
    } else {
        log.emerg("entry point glEnableVertexAttribArray not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveAttrib")) |proc| {
        function_pointers.glGetActiveAttrib = @ptrCast(?function_signatures.glGetActiveAttrib,  proc);
    } else {
        log.emerg("entry point glGetActiveAttrib not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveUniform")) |proc| {
        function_pointers.glGetActiveUniform = @ptrCast(?function_signatures.glGetActiveUniform,  proc);
    } else {
        log.emerg("entry point glGetActiveUniform not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetAttachedShaders")) |proc| {
        function_pointers.glGetAttachedShaders = @ptrCast(?function_signatures.glGetAttachedShaders,  proc);
    } else {
        log.emerg("entry point glGetAttachedShaders not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetAttribLocation")) |proc| {
        function_pointers.glGetAttribLocation = @ptrCast(?function_signatures.glGetAttribLocation,  proc);
    } else {
        log.emerg("entry point glGetAttribLocation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetProgramiv")) |proc| {
        function_pointers.glGetProgramiv = @ptrCast(?function_signatures.glGetProgramiv,  proc);
    } else {
        log.emerg("entry point glGetProgramiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetProgramInfoLog")) |proc| {
        function_pointers.glGetProgramInfoLog = @ptrCast(?function_signatures.glGetProgramInfoLog,  proc);
    } else {
        log.emerg("entry point glGetProgramInfoLog not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetShaderiv")) |proc| {
        function_pointers.glGetShaderiv = @ptrCast(?function_signatures.glGetShaderiv,  proc);
    } else {
        log.emerg("entry point glGetShaderiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetShaderInfoLog")) |proc| {
        function_pointers.glGetShaderInfoLog = @ptrCast(?function_signatures.glGetShaderInfoLog,  proc);
    } else {
        log.emerg("entry point glGetShaderInfoLog not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetShaderSource")) |proc| {
        function_pointers.glGetShaderSource = @ptrCast(?function_signatures.glGetShaderSource,  proc);
    } else {
        log.emerg("entry point glGetShaderSource not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformLocation")) |proc| {
        function_pointers.glGetUniformLocation = @ptrCast(?function_signatures.glGetUniformLocation,  proc);
    } else {
        log.emerg("entry point glGetUniformLocation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformfv")) |proc| {
        function_pointers.glGetUniformfv = @ptrCast(?function_signatures.glGetUniformfv,  proc);
    } else {
        log.emerg("entry point glGetUniformfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformiv")) |proc| {
        function_pointers.glGetUniformiv = @ptrCast(?function_signatures.glGetUniformiv,  proc);
    } else {
        log.emerg("entry point glGetUniformiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribdv")) |proc| {
        function_pointers.glGetVertexAttribdv = @ptrCast(?function_signatures.glGetVertexAttribdv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribdv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribfv")) |proc| {
        function_pointers.glGetVertexAttribfv = @ptrCast(?function_signatures.glGetVertexAttribfv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribiv")) |proc| {
        function_pointers.glGetVertexAttribiv = @ptrCast(?function_signatures.glGetVertexAttribiv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribPointerv")) |proc| {
        function_pointers.glGetVertexAttribPointerv = @ptrCast(?function_signatures.glGetVertexAttribPointerv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribPointerv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsProgram")) |proc| {
        function_pointers.glIsProgram = @ptrCast(?function_signatures.glIsProgram,  proc);
    } else {
        log.emerg("entry point glIsProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsShader")) |proc| {
        function_pointers.glIsShader = @ptrCast(?function_signatures.glIsShader,  proc);
    } else {
        log.emerg("entry point glIsShader not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glLinkProgram")) |proc| {
        function_pointers.glLinkProgram = @ptrCast(?function_signatures.glLinkProgram,  proc);
    } else {
        log.emerg("entry point glLinkProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glShaderSource")) |proc| {
        function_pointers.glShaderSource = @ptrCast(?function_signatures.glShaderSource,  proc);
    } else {
        log.emerg("entry point glShaderSource not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUseProgram")) |proc| {
        function_pointers.glUseProgram = @ptrCast(?function_signatures.glUseProgram,  proc);
    } else {
        log.emerg("entry point glUseProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1f")) |proc| {
        function_pointers.glUniform1f = @ptrCast(?function_signatures.glUniform1f,  proc);
    } else {
        log.emerg("entry point glUniform1f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2f")) |proc| {
        function_pointers.glUniform2f = @ptrCast(?function_signatures.glUniform2f,  proc);
    } else {
        log.emerg("entry point glUniform2f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3f")) |proc| {
        function_pointers.glUniform3f = @ptrCast(?function_signatures.glUniform3f,  proc);
    } else {
        log.emerg("entry point glUniform3f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4f")) |proc| {
        function_pointers.glUniform4f = @ptrCast(?function_signatures.glUniform4f,  proc);
    } else {
        log.emerg("entry point glUniform4f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1i")) |proc| {
        function_pointers.glUniform1i = @ptrCast(?function_signatures.glUniform1i,  proc);
    } else {
        log.emerg("entry point glUniform1i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2i")) |proc| {
        function_pointers.glUniform2i = @ptrCast(?function_signatures.glUniform2i,  proc);
    } else {
        log.emerg("entry point glUniform2i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3i")) |proc| {
        function_pointers.glUniform3i = @ptrCast(?function_signatures.glUniform3i,  proc);
    } else {
        log.emerg("entry point glUniform3i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4i")) |proc| {
        function_pointers.glUniform4i = @ptrCast(?function_signatures.glUniform4i,  proc);
    } else {
        log.emerg("entry point glUniform4i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1fv")) |proc| {
        function_pointers.glUniform1fv = @ptrCast(?function_signatures.glUniform1fv,  proc);
    } else {
        log.emerg("entry point glUniform1fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2fv")) |proc| {
        function_pointers.glUniform2fv = @ptrCast(?function_signatures.glUniform2fv,  proc);
    } else {
        log.emerg("entry point glUniform2fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3fv")) |proc| {
        function_pointers.glUniform3fv = @ptrCast(?function_signatures.glUniform3fv,  proc);
    } else {
        log.emerg("entry point glUniform3fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4fv")) |proc| {
        function_pointers.glUniform4fv = @ptrCast(?function_signatures.glUniform4fv,  proc);
    } else {
        log.emerg("entry point glUniform4fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1iv")) |proc| {
        function_pointers.glUniform1iv = @ptrCast(?function_signatures.glUniform1iv,  proc);
    } else {
        log.emerg("entry point glUniform1iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2iv")) |proc| {
        function_pointers.glUniform2iv = @ptrCast(?function_signatures.glUniform2iv,  proc);
    } else {
        log.emerg("entry point glUniform2iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3iv")) |proc| {
        function_pointers.glUniform3iv = @ptrCast(?function_signatures.glUniform3iv,  proc);
    } else {
        log.emerg("entry point glUniform3iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4iv")) |proc| {
        function_pointers.glUniform4iv = @ptrCast(?function_signatures.glUniform4iv,  proc);
    } else {
        log.emerg("entry point glUniform4iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix2fv")) |proc| {
        function_pointers.glUniformMatrix2fv = @ptrCast(?function_signatures.glUniformMatrix2fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix2fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix3fv")) |proc| {
        function_pointers.glUniformMatrix3fv = @ptrCast(?function_signatures.glUniformMatrix3fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix3fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix4fv")) |proc| {
        function_pointers.glUniformMatrix4fv = @ptrCast(?function_signatures.glUniformMatrix4fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix4fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glValidateProgram")) |proc| {
        function_pointers.glValidateProgram = @ptrCast(?function_signatures.glValidateProgram,  proc);
    } else {
        log.emerg("entry point glValidateProgram not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1d")) |proc| {
        function_pointers.glVertexAttrib1d = @ptrCast(?function_signatures.glVertexAttrib1d,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1d not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1dv")) |proc| {
        function_pointers.glVertexAttrib1dv = @ptrCast(?function_signatures.glVertexAttrib1dv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1dv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1f")) |proc| {
        function_pointers.glVertexAttrib1f = @ptrCast(?function_signatures.glVertexAttrib1f,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1fv")) |proc| {
        function_pointers.glVertexAttrib1fv = @ptrCast(?function_signatures.glVertexAttrib1fv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1s")) |proc| {
        function_pointers.glVertexAttrib1s = @ptrCast(?function_signatures.glVertexAttrib1s,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1s not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib1sv")) |proc| {
        function_pointers.glVertexAttrib1sv = @ptrCast(?function_signatures.glVertexAttrib1sv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib1sv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2d")) |proc| {
        function_pointers.glVertexAttrib2d = @ptrCast(?function_signatures.glVertexAttrib2d,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2d not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2dv")) |proc| {
        function_pointers.glVertexAttrib2dv = @ptrCast(?function_signatures.glVertexAttrib2dv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2dv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2f")) |proc| {
        function_pointers.glVertexAttrib2f = @ptrCast(?function_signatures.glVertexAttrib2f,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2fv")) |proc| {
        function_pointers.glVertexAttrib2fv = @ptrCast(?function_signatures.glVertexAttrib2fv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2s")) |proc| {
        function_pointers.glVertexAttrib2s = @ptrCast(?function_signatures.glVertexAttrib2s,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2s not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib2sv")) |proc| {
        function_pointers.glVertexAttrib2sv = @ptrCast(?function_signatures.glVertexAttrib2sv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib2sv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3d")) |proc| {
        function_pointers.glVertexAttrib3d = @ptrCast(?function_signatures.glVertexAttrib3d,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3d not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3dv")) |proc| {
        function_pointers.glVertexAttrib3dv = @ptrCast(?function_signatures.glVertexAttrib3dv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3dv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3f")) |proc| {
        function_pointers.glVertexAttrib3f = @ptrCast(?function_signatures.glVertexAttrib3f,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3fv")) |proc| {
        function_pointers.glVertexAttrib3fv = @ptrCast(?function_signatures.glVertexAttrib3fv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3s")) |proc| {
        function_pointers.glVertexAttrib3s = @ptrCast(?function_signatures.glVertexAttrib3s,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3s not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib3sv")) |proc| {
        function_pointers.glVertexAttrib3sv = @ptrCast(?function_signatures.glVertexAttrib3sv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib3sv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nbv")) |proc| {
        function_pointers.glVertexAttrib4Nbv = @ptrCast(?function_signatures.glVertexAttrib4Nbv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nbv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Niv")) |proc| {
        function_pointers.glVertexAttrib4Niv = @ptrCast(?function_signatures.glVertexAttrib4Niv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Niv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nsv")) |proc| {
        function_pointers.glVertexAttrib4Nsv = @ptrCast(?function_signatures.glVertexAttrib4Nsv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nsv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nub")) |proc| {
        function_pointers.glVertexAttrib4Nub = @ptrCast(?function_signatures.glVertexAttrib4Nub,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nub not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nubv")) |proc| {
        function_pointers.glVertexAttrib4Nubv = @ptrCast(?function_signatures.glVertexAttrib4Nubv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nubv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nuiv")) |proc| {
        function_pointers.glVertexAttrib4Nuiv = @ptrCast(?function_signatures.glVertexAttrib4Nuiv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4Nusv")) |proc| {
        function_pointers.glVertexAttrib4Nusv = @ptrCast(?function_signatures.glVertexAttrib4Nusv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4Nusv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4bv")) |proc| {
        function_pointers.glVertexAttrib4bv = @ptrCast(?function_signatures.glVertexAttrib4bv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4bv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4d")) |proc| {
        function_pointers.glVertexAttrib4d = @ptrCast(?function_signatures.glVertexAttrib4d,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4d not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4dv")) |proc| {
        function_pointers.glVertexAttrib4dv = @ptrCast(?function_signatures.glVertexAttrib4dv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4dv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4f")) |proc| {
        function_pointers.glVertexAttrib4f = @ptrCast(?function_signatures.glVertexAttrib4f,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4f not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4fv")) |proc| {
        function_pointers.glVertexAttrib4fv = @ptrCast(?function_signatures.glVertexAttrib4fv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4iv")) |proc| {
        function_pointers.glVertexAttrib4iv = @ptrCast(?function_signatures.glVertexAttrib4iv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4s")) |proc| {
        function_pointers.glVertexAttrib4s = @ptrCast(?function_signatures.glVertexAttrib4s,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4s not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4sv")) |proc| {
        function_pointers.glVertexAttrib4sv = @ptrCast(?function_signatures.glVertexAttrib4sv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4sv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4ubv")) |proc| {
        function_pointers.glVertexAttrib4ubv = @ptrCast(?function_signatures.glVertexAttrib4ubv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4ubv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4uiv")) |proc| {
        function_pointers.glVertexAttrib4uiv = @ptrCast(?function_signatures.glVertexAttrib4uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttrib4usv")) |proc| {
        function_pointers.glVertexAttrib4usv = @ptrCast(?function_signatures.glVertexAttrib4usv,  proc);
    } else {
        log.emerg("entry point glVertexAttrib4usv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribPointer")) |proc| {
        function_pointers.glVertexAttribPointer = @ptrCast(?function_signatures.glVertexAttribPointer,  proc);
    } else {
        log.emerg("entry point glVertexAttribPointer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix2x3fv")) |proc| {
        function_pointers.glUniformMatrix2x3fv = @ptrCast(?function_signatures.glUniformMatrix2x3fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix2x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix3x2fv")) |proc| {
        function_pointers.glUniformMatrix3x2fv = @ptrCast(?function_signatures.glUniformMatrix3x2fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix3x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix2x4fv")) |proc| {
        function_pointers.glUniformMatrix2x4fv = @ptrCast(?function_signatures.glUniformMatrix2x4fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix2x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix4x2fv")) |proc| {
        function_pointers.glUniformMatrix4x2fv = @ptrCast(?function_signatures.glUniformMatrix4x2fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix4x2fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix3x4fv")) |proc| {
        function_pointers.glUniformMatrix3x4fv = @ptrCast(?function_signatures.glUniformMatrix3x4fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix3x4fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformMatrix4x3fv")) |proc| {
        function_pointers.glUniformMatrix4x3fv = @ptrCast(?function_signatures.glUniformMatrix4x3fv,  proc);
    } else {
        log.emerg("entry point glUniformMatrix4x3fv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glColorMaski")) |proc| {
        function_pointers.glColorMaski = @ptrCast(?function_signatures.glColorMaski,  proc);
    } else {
        log.emerg("entry point glColorMaski not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetBooleani_v")) |proc| {
        function_pointers.glGetBooleani_v = @ptrCast(?function_signatures.glGetBooleani_v,  proc);
    } else {
        log.emerg("entry point glGetBooleani_v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetIntegeri_v")) |proc| {
        function_pointers.glGetIntegeri_v = @ptrCast(?function_signatures.glGetIntegeri_v,  proc);
    } else {
        log.emerg("entry point glGetIntegeri_v not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEnablei")) |proc| {
        function_pointers.glEnablei = @ptrCast(?function_signatures.glEnablei,  proc);
    } else {
        log.emerg("entry point glEnablei not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDisablei")) |proc| {
        function_pointers.glDisablei = @ptrCast(?function_signatures.glDisablei,  proc);
    } else {
        log.emerg("entry point glDisablei not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsEnabledi")) |proc| {
        function_pointers.glIsEnabledi = @ptrCast(?function_signatures.glIsEnabledi,  proc);
    } else {
        log.emerg("entry point glIsEnabledi not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBeginTransformFeedback")) |proc| {
        function_pointers.glBeginTransformFeedback = @ptrCast(?function_signatures.glBeginTransformFeedback,  proc);
    } else {
        log.emerg("entry point glBeginTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEndTransformFeedback")) |proc| {
        function_pointers.glEndTransformFeedback = @ptrCast(?function_signatures.glEndTransformFeedback,  proc);
    } else {
        log.emerg("entry point glEndTransformFeedback not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindBufferRange")) |proc| {
        function_pointers.glBindBufferRange = @ptrCast(?function_signatures.glBindBufferRange,  proc);
    } else {
        log.emerg("entry point glBindBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindBufferBase")) |proc| {
        function_pointers.glBindBufferBase = @ptrCast(?function_signatures.glBindBufferBase,  proc);
    } else {
        log.emerg("entry point glBindBufferBase not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTransformFeedbackVaryings")) |proc| {
        function_pointers.glTransformFeedbackVaryings = @ptrCast(?function_signatures.glTransformFeedbackVaryings,  proc);
    } else {
        log.emerg("entry point glTransformFeedbackVaryings not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTransformFeedbackVarying")) |proc| {
        function_pointers.glGetTransformFeedbackVarying = @ptrCast(?function_signatures.glGetTransformFeedbackVarying,  proc);
    } else {
        log.emerg("entry point glGetTransformFeedbackVarying not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClampColor")) |proc| {
        function_pointers.glClampColor = @ptrCast(?function_signatures.glClampColor,  proc);
    } else {
        log.emerg("entry point glClampColor not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBeginConditionalRender")) |proc| {
        function_pointers.glBeginConditionalRender = @ptrCast(?function_signatures.glBeginConditionalRender,  proc);
    } else {
        log.emerg("entry point glBeginConditionalRender not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glEndConditionalRender")) |proc| {
        function_pointers.glEndConditionalRender = @ptrCast(?function_signatures.glEndConditionalRender,  proc);
    } else {
        log.emerg("entry point glEndConditionalRender not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribIPointer")) |proc| {
        function_pointers.glVertexAttribIPointer = @ptrCast(?function_signatures.glVertexAttribIPointer,  proc);
    } else {
        log.emerg("entry point glVertexAttribIPointer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribIiv")) |proc| {
        function_pointers.glGetVertexAttribIiv = @ptrCast(?function_signatures.glGetVertexAttribIiv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetVertexAttribIuiv")) |proc| {
        function_pointers.glGetVertexAttribIuiv = @ptrCast(?function_signatures.glGetVertexAttribIuiv,  proc);
    } else {
        log.emerg("entry point glGetVertexAttribIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI1i")) |proc| {
        function_pointers.glVertexAttribI1i = @ptrCast(?function_signatures.glVertexAttribI1i,  proc);
    } else {
        log.emerg("entry point glVertexAttribI1i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI2i")) |proc| {
        function_pointers.glVertexAttribI2i = @ptrCast(?function_signatures.glVertexAttribI2i,  proc);
    } else {
        log.emerg("entry point glVertexAttribI2i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI3i")) |proc| {
        function_pointers.glVertexAttribI3i = @ptrCast(?function_signatures.glVertexAttribI3i,  proc);
    } else {
        log.emerg("entry point glVertexAttribI3i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4i")) |proc| {
        function_pointers.glVertexAttribI4i = @ptrCast(?function_signatures.glVertexAttribI4i,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4i not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI1ui")) |proc| {
        function_pointers.glVertexAttribI1ui = @ptrCast(?function_signatures.glVertexAttribI1ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribI1ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI2ui")) |proc| {
        function_pointers.glVertexAttribI2ui = @ptrCast(?function_signatures.glVertexAttribI2ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribI2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI3ui")) |proc| {
        function_pointers.glVertexAttribI3ui = @ptrCast(?function_signatures.glVertexAttribI3ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribI3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4ui")) |proc| {
        function_pointers.glVertexAttribI4ui = @ptrCast(?function_signatures.glVertexAttribI4ui,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI1iv")) |proc| {
        function_pointers.glVertexAttribI1iv = @ptrCast(?function_signatures.glVertexAttribI1iv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI1iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI2iv")) |proc| {
        function_pointers.glVertexAttribI2iv = @ptrCast(?function_signatures.glVertexAttribI2iv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI2iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI3iv")) |proc| {
        function_pointers.glVertexAttribI3iv = @ptrCast(?function_signatures.glVertexAttribI3iv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI3iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4iv")) |proc| {
        function_pointers.glVertexAttribI4iv = @ptrCast(?function_signatures.glVertexAttribI4iv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4iv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI1uiv")) |proc| {
        function_pointers.glVertexAttribI1uiv = @ptrCast(?function_signatures.glVertexAttribI1uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI2uiv")) |proc| {
        function_pointers.glVertexAttribI2uiv = @ptrCast(?function_signatures.glVertexAttribI2uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI3uiv")) |proc| {
        function_pointers.glVertexAttribI3uiv = @ptrCast(?function_signatures.glVertexAttribI3uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4uiv")) |proc| {
        function_pointers.glVertexAttribI4uiv = @ptrCast(?function_signatures.glVertexAttribI4uiv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4bv")) |proc| {
        function_pointers.glVertexAttribI4bv = @ptrCast(?function_signatures.glVertexAttribI4bv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4bv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4sv")) |proc| {
        function_pointers.glVertexAttribI4sv = @ptrCast(?function_signatures.glVertexAttribI4sv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4sv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4ubv")) |proc| {
        function_pointers.glVertexAttribI4ubv = @ptrCast(?function_signatures.glVertexAttribI4ubv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4ubv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glVertexAttribI4usv")) |proc| {
        function_pointers.glVertexAttribI4usv = @ptrCast(?function_signatures.glVertexAttribI4usv,  proc);
    } else {
        log.emerg("entry point glVertexAttribI4usv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformuiv")) |proc| {
        function_pointers.glGetUniformuiv = @ptrCast(?function_signatures.glGetUniformuiv,  proc);
    } else {
        log.emerg("entry point glGetUniformuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindFragDataLocation")) |proc| {
        function_pointers.glBindFragDataLocation = @ptrCast(?function_signatures.glBindFragDataLocation,  proc);
    } else {
        log.emerg("entry point glBindFragDataLocation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetFragDataLocation")) |proc| {
        function_pointers.glGetFragDataLocation = @ptrCast(?function_signatures.glGetFragDataLocation,  proc);
    } else {
        log.emerg("entry point glGetFragDataLocation not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1ui")) |proc| {
        function_pointers.glUniform1ui = @ptrCast(?function_signatures.glUniform1ui,  proc);
    } else {
        log.emerg("entry point glUniform1ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2ui")) |proc| {
        function_pointers.glUniform2ui = @ptrCast(?function_signatures.glUniform2ui,  proc);
    } else {
        log.emerg("entry point glUniform2ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3ui")) |proc| {
        function_pointers.glUniform3ui = @ptrCast(?function_signatures.glUniform3ui,  proc);
    } else {
        log.emerg("entry point glUniform3ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4ui")) |proc| {
        function_pointers.glUniform4ui = @ptrCast(?function_signatures.glUniform4ui,  proc);
    } else {
        log.emerg("entry point glUniform4ui not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform1uiv")) |proc| {
        function_pointers.glUniform1uiv = @ptrCast(?function_signatures.glUniform1uiv,  proc);
    } else {
        log.emerg("entry point glUniform1uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform2uiv")) |proc| {
        function_pointers.glUniform2uiv = @ptrCast(?function_signatures.glUniform2uiv,  proc);
    } else {
        log.emerg("entry point glUniform2uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform3uiv")) |proc| {
        function_pointers.glUniform3uiv = @ptrCast(?function_signatures.glUniform3uiv,  proc);
    } else {
        log.emerg("entry point glUniform3uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniform4uiv")) |proc| {
        function_pointers.glUniform4uiv = @ptrCast(?function_signatures.glUniform4uiv,  proc);
    } else {
        log.emerg("entry point glUniform4uiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameterIiv")) |proc| {
        function_pointers.glTexParameterIiv = @ptrCast(?function_signatures.glTexParameterIiv,  proc);
    } else {
        log.emerg("entry point glTexParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexParameterIuiv")) |proc| {
        function_pointers.glTexParameterIuiv = @ptrCast(?function_signatures.glTexParameterIuiv,  proc);
    } else {
        log.emerg("entry point glTexParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexParameterIiv")) |proc| {
        function_pointers.glGetTexParameterIiv = @ptrCast(?function_signatures.glGetTexParameterIiv,  proc);
    } else {
        log.emerg("entry point glGetTexParameterIiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetTexParameterIuiv")) |proc| {
        function_pointers.glGetTexParameterIuiv = @ptrCast(?function_signatures.glGetTexParameterIuiv,  proc);
    } else {
        log.emerg("entry point glGetTexParameterIuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearBufferiv")) |proc| {
        function_pointers.glClearBufferiv = @ptrCast(?function_signatures.glClearBufferiv,  proc);
    } else {
        log.emerg("entry point glClearBufferiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearBufferuiv")) |proc| {
        function_pointers.glClearBufferuiv = @ptrCast(?function_signatures.glClearBufferuiv,  proc);
    } else {
        log.emerg("entry point glClearBufferuiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearBufferfv")) |proc| {
        function_pointers.glClearBufferfv = @ptrCast(?function_signatures.glClearBufferfv,  proc);
    } else {
        log.emerg("entry point glClearBufferfv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glClearBufferfi")) |proc| {
        function_pointers.glClearBufferfi = @ptrCast(?function_signatures.glClearBufferfi,  proc);
    } else {
        log.emerg("entry point glClearBufferfi not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetStringi")) |proc| {
        function_pointers.glGetStringi = @ptrCast(?function_signatures.glGetStringi,  proc);
    } else {
        log.emerg("entry point glGetStringi not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsRenderbuffer")) |proc| {
        function_pointers.glIsRenderbuffer = @ptrCast(?function_signatures.glIsRenderbuffer,  proc);
    } else {
        log.emerg("entry point glIsRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindRenderbuffer")) |proc| {
        function_pointers.glBindRenderbuffer = @ptrCast(?function_signatures.glBindRenderbuffer,  proc);
    } else {
        log.emerg("entry point glBindRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteRenderbuffers")) |proc| {
        function_pointers.glDeleteRenderbuffers = @ptrCast(?function_signatures.glDeleteRenderbuffers,  proc);
    } else {
        log.emerg("entry point glDeleteRenderbuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenRenderbuffers")) |proc| {
        function_pointers.glGenRenderbuffers = @ptrCast(?function_signatures.glGenRenderbuffers,  proc);
    } else {
        log.emerg("entry point glGenRenderbuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glRenderbufferStorage")) |proc| {
        function_pointers.glRenderbufferStorage = @ptrCast(?function_signatures.glRenderbufferStorage,  proc);
    } else {
        log.emerg("entry point glRenderbufferStorage not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetRenderbufferParameteriv")) |proc| {
        function_pointers.glGetRenderbufferParameteriv = @ptrCast(?function_signatures.glGetRenderbufferParameteriv,  proc);
    } else {
        log.emerg("entry point glGetRenderbufferParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsFramebuffer")) |proc| {
        function_pointers.glIsFramebuffer = @ptrCast(?function_signatures.glIsFramebuffer,  proc);
    } else {
        log.emerg("entry point glIsFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindFramebuffer")) |proc| {
        function_pointers.glBindFramebuffer = @ptrCast(?function_signatures.glBindFramebuffer,  proc);
    } else {
        log.emerg("entry point glBindFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteFramebuffers")) |proc| {
        function_pointers.glDeleteFramebuffers = @ptrCast(?function_signatures.glDeleteFramebuffers,  proc);
    } else {
        log.emerg("entry point glDeleteFramebuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenFramebuffers")) |proc| {
        function_pointers.glGenFramebuffers = @ptrCast(?function_signatures.glGenFramebuffers,  proc);
    } else {
        log.emerg("entry point glGenFramebuffers not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCheckFramebufferStatus")) |proc| {
        function_pointers.glCheckFramebufferStatus = @ptrCast(?function_signatures.glCheckFramebufferStatus,  proc);
    } else {
        log.emerg("entry point glCheckFramebufferStatus not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferTexture1D")) |proc| {
        function_pointers.glFramebufferTexture1D = @ptrCast(?function_signatures.glFramebufferTexture1D,  proc);
    } else {
        log.emerg("entry point glFramebufferTexture1D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferTexture2D")) |proc| {
        function_pointers.glFramebufferTexture2D = @ptrCast(?function_signatures.glFramebufferTexture2D,  proc);
    } else {
        log.emerg("entry point glFramebufferTexture2D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferTexture3D")) |proc| {
        function_pointers.glFramebufferTexture3D = @ptrCast(?function_signatures.glFramebufferTexture3D,  proc);
    } else {
        log.emerg("entry point glFramebufferTexture3D not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferRenderbuffer")) |proc| {
        function_pointers.glFramebufferRenderbuffer = @ptrCast(?function_signatures.glFramebufferRenderbuffer,  proc);
    } else {
        log.emerg("entry point glFramebufferRenderbuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetFramebufferAttachmentParameteriv")) |proc| {
        function_pointers.glGetFramebufferAttachmentParameteriv = @ptrCast(?function_signatures.glGetFramebufferAttachmentParameteriv,  proc);
    } else {
        log.emerg("entry point glGetFramebufferAttachmentParameteriv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenerateMipmap")) |proc| {
        function_pointers.glGenerateMipmap = @ptrCast(?function_signatures.glGenerateMipmap,  proc);
    } else {
        log.emerg("entry point glGenerateMipmap not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBlitFramebuffer")) |proc| {
        function_pointers.glBlitFramebuffer = @ptrCast(?function_signatures.glBlitFramebuffer,  proc);
    } else {
        log.emerg("entry point glBlitFramebuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glRenderbufferStorageMultisample")) |proc| {
        function_pointers.glRenderbufferStorageMultisample = @ptrCast(?function_signatures.glRenderbufferStorageMultisample,  proc);
    } else {
        log.emerg("entry point glRenderbufferStorageMultisample not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFramebufferTextureLayer")) |proc| {
        function_pointers.glFramebufferTextureLayer = @ptrCast(?function_signatures.glFramebufferTextureLayer,  proc);
    } else {
        log.emerg("entry point glFramebufferTextureLayer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glMapBufferRange")) |proc| {
        function_pointers.glMapBufferRange = @ptrCast(?function_signatures.glMapBufferRange,  proc);
    } else {
        log.emerg("entry point glMapBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glFlushMappedBufferRange")) |proc| {
        function_pointers.glFlushMappedBufferRange = @ptrCast(?function_signatures.glFlushMappedBufferRange,  proc);
    } else {
        log.emerg("entry point glFlushMappedBufferRange not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glBindVertexArray")) |proc| {
        function_pointers.glBindVertexArray = @ptrCast(?function_signatures.glBindVertexArray,  proc);
    } else {
        log.emerg("entry point glBindVertexArray not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDeleteVertexArrays")) |proc| {
        function_pointers.glDeleteVertexArrays = @ptrCast(?function_signatures.glDeleteVertexArrays,  proc);
    } else {
        log.emerg("entry point glDeleteVertexArrays not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGenVertexArrays")) |proc| {
        function_pointers.glGenVertexArrays = @ptrCast(?function_signatures.glGenVertexArrays,  proc);
    } else {
        log.emerg("entry point glGenVertexArrays not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glIsVertexArray")) |proc| {
        function_pointers.glIsVertexArray = @ptrCast(?function_signatures.glIsVertexArray,  proc);
    } else {
        log.emerg("entry point glIsVertexArray not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawArraysInstanced")) |proc| {
        function_pointers.glDrawArraysInstanced = @ptrCast(?function_signatures.glDrawArraysInstanced,  proc);
    } else {
        log.emerg("entry point glDrawArraysInstanced not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glDrawElementsInstanced")) |proc| {
        function_pointers.glDrawElementsInstanced = @ptrCast(?function_signatures.glDrawElementsInstanced,  proc);
    } else {
        log.emerg("entry point glDrawElementsInstanced not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glTexBuffer")) |proc| {
        function_pointers.glTexBuffer = @ptrCast(?function_signatures.glTexBuffer,  proc);
    } else {
        log.emerg("entry point glTexBuffer not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glPrimitiveRestartIndex")) |proc| {
        function_pointers.glPrimitiveRestartIndex = @ptrCast(?function_signatures.glPrimitiveRestartIndex,  proc);
    } else {
        log.emerg("entry point glPrimitiveRestartIndex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glCopyBufferSubData")) |proc| {
        function_pointers.glCopyBufferSubData = @ptrCast(?function_signatures.glCopyBufferSubData,  proc);
    } else {
        log.emerg("entry point glCopyBufferSubData not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformIndices")) |proc| {
        function_pointers.glGetUniformIndices = @ptrCast(?function_signatures.glGetUniformIndices,  proc);
    } else {
        log.emerg("entry point glGetUniformIndices not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveUniformsiv")) |proc| {
        function_pointers.glGetActiveUniformsiv = @ptrCast(?function_signatures.glGetActiveUniformsiv,  proc);
    } else {
        log.emerg("entry point glGetActiveUniformsiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveUniformName")) |proc| {
        function_pointers.glGetActiveUniformName = @ptrCast(?function_signatures.glGetActiveUniformName,  proc);
    } else {
        log.emerg("entry point glGetActiveUniformName not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetUniformBlockIndex")) |proc| {
        function_pointers.glGetUniformBlockIndex = @ptrCast(?function_signatures.glGetUniformBlockIndex,  proc);
    } else {
        log.emerg("entry point glGetUniformBlockIndex not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveUniformBlockiv")) |proc| {
        function_pointers.glGetActiveUniformBlockiv = @ptrCast(?function_signatures.glGetActiveUniformBlockiv,  proc);
    } else {
        log.emerg("entry point glGetActiveUniformBlockiv not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glGetActiveUniformBlockName")) |proc| {
        function_pointers.glGetActiveUniformBlockName = @ptrCast(?function_signatures.glGetActiveUniformBlockName,  proc);
    } else {
        log.emerg("entry point glGetActiveUniformBlockName not found!", .{});
        success = false;
    }
    if(get_proc_address(load_ctx, "glUniformBlockBinding")) |proc| {
        function_pointers.glUniformBlockBinding = @ptrCast(?function_signatures.glUniformBlockBinding,  proc);
    } else {
        log.emerg("entry point glUniformBlockBinding not found!", .{});
        success = false;
    }
    if(!success)
        return error.EntryPointNotFound;
}

const function_signatures = struct {
    const glCullFace = fn(mode: GLenum) void;
    const glFrontFace = fn(mode: GLenum) void;
    const glHint = fn(target: GLenum, mode: GLenum) void;
    const glLineWidth = fn(width: GLfloat) void;
    const glPointSize = fn(size: GLfloat) void;
    const glPolygonMode = fn(face: GLenum, mode: GLenum) void;
    const glScissor = fn(x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glTexParameterf = fn(target: GLenum, pname: GLenum, param: GLfloat) void;
    const glTexParameterfv = fn(target: GLenum, pname: GLenum, params: [*c]const GLfloat) void;
    const glTexParameteri = fn(target: GLenum, pname: GLenum, param: GLint) void;
    const glTexParameteriv = fn(target: GLenum, pname: GLenum, params: [*c]const GLint) void;
    const glTexImage1D = fn(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glTexImage2D = fn(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glDrawBuffer = fn(buf: GLenum) void;
    const glClear = fn(mask: GLbitfield) void;
    const glClearColor = fn(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) void;
    const glClearStencil = fn(s: GLint) void;
    const glClearDepth = fn(depth: GLdouble) void;
    const glStencilMask = fn(mask: GLuint) void;
    const glColorMask = fn(red: GLboolean, green: GLboolean, blue: GLboolean, alpha: GLboolean) void;
    const glDepthMask = fn(flag: GLboolean) void;
    const glDisable = fn(cap: GLenum) void;
    const glEnable = fn(cap: GLenum) void;
    const glFinish = fn() void;
    const glFlush = fn() void;
    const glBlendFunc = fn(sfactor: GLenum, dfactor: GLenum) void;
    const glLogicOp = fn(opcode: GLenum) void;
    const glStencilFunc = fn(func: GLenum, ref: GLint, mask: GLuint) void;
    const glStencilOp = fn(fail: GLenum, zfail: GLenum, zpass: GLenum) void;
    const glDepthFunc = fn(func: GLenum) void;
    const glPixelStoref = fn(pname: GLenum, param: GLfloat) void;
    const glPixelStorei = fn(pname: GLenum, param: GLint) void;
    const glReadBuffer = fn(src: GLenum) void;
    const glReadPixels = fn(x: GLint, y: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *c_void) void;
    const glGetBooleanv = fn(pname: GLenum, data: [*c]GLboolean) void;
    const glGetDoublev = fn(pname: GLenum, data: [*c]GLdouble) void;
    const glGetError = fn() GLenum;
    const glGetFloatv = fn(pname: GLenum, data: [*c]GLfloat) void;
    const glGetIntegerv = fn(pname: GLenum, data: [*c]GLint) void;
    const glGetString = fn(name: GLenum) [*:0]const GLubyte;
    const glGetTexImage = fn(target: GLenum, level: GLint, format: GLenum, type: GLenum, pixels: *c_void) void;
    const glGetTexParameterfv = fn(target: GLenum, pname: GLenum, params: [*c]GLfloat) void;
    const glGetTexParameteriv = fn(target: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glGetTexLevelParameterfv = fn(target: GLenum, level: GLint, pname: GLenum, params: [*c]GLfloat) void;
    const glGetTexLevelParameteriv = fn(target: GLenum, level: GLint, pname: GLenum, params: [*c]GLint) void;
    const glIsEnabled = fn(cap: GLenum) GLboolean;
    const glDepthRange = fn(n: GLdouble, f: GLdouble) void;
    const glViewport = fn(x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glDrawArrays = fn(mode: GLenum, first: GLint, count: GLsizei) void;
    const glDrawElements = fn(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void) void;
    const glPolygonOffset = fn(factor: GLfloat, units: GLfloat) void;
    const glCopyTexImage1D = fn(target: GLenum, level: GLint, internalformat: GLenum, x: GLint, y: GLint, width: GLsizei, border: GLint) void;
    const glCopyTexImage2D = fn(target: GLenum, level: GLint, internalformat: GLenum, x: GLint, y: GLint, width: GLsizei, height: GLsizei, border: GLint) void;
    const glCopyTexSubImage1D = fn(target: GLenum, level: GLint, xoffset: GLint, x: GLint, y: GLint, width: GLsizei) void;
    const glCopyTexSubImage2D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glTexSubImage1D = fn(target: GLenum, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glTexSubImage2D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glBindTexture = fn(target: GLenum, texture: GLuint) void;
    const glDeleteTextures = fn(n: GLsizei, textures: [*c]const GLuint) void;
    const glGenTextures = fn(n: GLsizei, textures: [*c]GLuint) void;
    const glIsTexture = fn(texture: GLuint) GLboolean;
    const glDrawRangeElements = fn(mode: GLenum, start: GLuint, end: GLuint, count: GLsizei, type: GLenum, indices: *const c_void) void;
    const glTexImage3D = fn(target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glTexSubImage3D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glCopyTexSubImage3D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glSecondaryColorP3uiv = fn(type: GLenum, color: [*c]const GLuint) void;
    const glSecondaryColorP3ui = fn(type: GLenum, color: GLuint) void;
    const glColorP4uiv = fn(type: GLenum, color: [*c]const GLuint) void;
    const glColorP4ui = fn(type: GLenum, color: GLuint) void;
    const glColorP3uiv = fn(type: GLenum, color: [*c]const GLuint) void;
    const glColorP3ui = fn(type: GLenum, color: GLuint) void;
    const glNormalP3uiv = fn(type: GLenum, coords: [*c]const GLuint) void;
    const glNormalP3ui = fn(type: GLenum, coords: GLuint) void;
    const glMultiTexCoordP4uiv = fn(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void;
    const glMultiTexCoordP4ui = fn(texture: GLenum, type: GLenum, coords: GLuint) void;
    const glMultiTexCoordP3uiv = fn(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void;
    const glMultiTexCoordP3ui = fn(texture: GLenum, type: GLenum, coords: GLuint) void;
    const glMultiTexCoordP2uiv = fn(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void;
    const glMultiTexCoordP2ui = fn(texture: GLenum, type: GLenum, coords: GLuint) void;
    const glMultiTexCoordP1uiv = fn(texture: GLenum, type: GLenum, coords: [*c]const GLuint) void;
    const glMultiTexCoordP1ui = fn(texture: GLenum, type: GLenum, coords: GLuint) void;
    const glTexCoordP4uiv = fn(type: GLenum, coords: [*c]const GLuint) void;
    const glTexCoordP4ui = fn(type: GLenum, coords: GLuint) void;
    const glTexCoordP3uiv = fn(type: GLenum, coords: [*c]const GLuint) void;
    const glTexCoordP3ui = fn(type: GLenum, coords: GLuint) void;
    const glActiveTexture = fn(texture: GLenum) void;
    const glSampleCoverage = fn(value: GLfloat, invert: GLboolean) void;
    const glCompressedTexImage3D = fn(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTexImage2D = fn(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, height: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTexImage1D = fn(target: GLenum, level: GLint, internalformat: GLenum, width: GLsizei, border: GLint, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTexSubImage3D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTexSubImage2D = fn(target: GLenum, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTexSubImage1D = fn(target: GLenum, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glGetCompressedTexImage = fn(target: GLenum, level: GLint, img: *c_void) void;
    const glTexCoordP2uiv = fn(type: GLenum, coords: [*c]const GLuint) void;
    const glTexCoordP2ui = fn(type: GLenum, coords: GLuint) void;
    const glTexCoordP1uiv = fn(type: GLenum, coords: [*c]const GLuint) void;
    const glTexCoordP1ui = fn(type: GLenum, coords: GLuint) void;
    const glVertexP4uiv = fn(type: GLenum, value: [*c]const GLuint) void;
    const glVertexP4ui = fn(type: GLenum, value: GLuint) void;
    const glVertexP3uiv = fn(type: GLenum, value: [*c]const GLuint) void;
    const glVertexP3ui = fn(type: GLenum, value: GLuint) void;
    const glVertexP2uiv = fn(type: GLenum, value: [*c]const GLuint) void;
    const glVertexP2ui = fn(type: GLenum, value: GLuint) void;
    const glVertexAttribP4uiv = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void;
    const glVertexAttribP4ui = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void;
    const glVertexAttribP3uiv = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void;
    const glVertexAttribP3ui = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void;
    const glVertexAttribP2uiv = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void;
    const glVertexAttribP2ui = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void;
    const glVertexAttribP1uiv = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: [*c]const GLuint) void;
    const glVertexAttribP1ui = fn(index: GLuint, type: GLenum, normalized: GLboolean, value: GLuint) void;
    const glVertexAttribDivisor = fn(index: GLuint, divisor: GLuint) void;
    const glGetQueryObjectui64v = fn(id: GLuint, pname: GLenum, params: [*c]GLuint64) void;
    const glGetQueryObjecti64v = fn(id: GLuint, pname: GLenum, params: [*c]GLint64) void;
    const glQueryCounter = fn(id: GLuint, target: GLenum) void;
    const glGetSamplerParameterIuiv = fn(sampler: GLuint, pname: GLenum, params: [*c]GLuint) void;
    const glGetSamplerParameterfv = fn(sampler: GLuint, pname: GLenum, params: [*c]GLfloat) void;
    const glGetSamplerParameterIiv = fn(sampler: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetSamplerParameteriv = fn(sampler: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glSamplerParameterIuiv = fn(sampler: GLuint, pname: GLenum, param: [*c]const GLuint) void;
    const glSamplerParameterIiv = fn(sampler: GLuint, pname: GLenum, param: [*c]const GLint) void;
    const glSamplerParameterfv = fn(sampler: GLuint, pname: GLenum, param: [*c]const GLfloat) void;
    const glSamplerParameterf = fn(sampler: GLuint, pname: GLenum, param: GLfloat) void;
    const glSamplerParameteriv = fn(sampler: GLuint, pname: GLenum, param: [*c]const GLint) void;
    const glSamplerParameteri = fn(sampler: GLuint, pname: GLenum, param: GLint) void;
    const glBindSampler = fn(unit: GLuint, sampler: GLuint) void;
    const glIsSampler = fn(sampler: GLuint) GLboolean;
    const glDeleteSamplers = fn(count: GLsizei, samplers: [*c]const GLuint) void;
    const glGenSamplers = fn(count: GLsizei, samplers: [*c]GLuint) void;
    const glGetFragDataIndex = fn(program: GLuint, name: [*c]const GLchar) GLint;
    const glBindFragDataLocationIndexed = fn(program: GLuint, colorNumber: GLuint, index: GLuint, name: [*c]const GLchar) void;
    const glSampleMaski = fn(maskNumber: GLuint, mask: GLbitfield) void;
    const glGetMultisamplefv = fn(pname: GLenum, index: GLuint, val: [*c]GLfloat) void;
    const glTexImage3DMultisample = fn(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, fixedsamplelocations: GLboolean) void;
    const glTexImage2DMultisample = fn(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, fixedsamplelocations: GLboolean) void;
    const glFramebufferTexture = fn(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint) void;
    const glGetBufferParameteri64v = fn(target: GLenum, pname: GLenum, params: [*c]GLint64) void;
    const glBlendFuncSeparate = fn(sfactorRGB: GLenum, dfactorRGB: GLenum, sfactorAlpha: GLenum, dfactorAlpha: GLenum) void;
    const glMultiDrawArrays = fn(mode: GLenum, first: [*c]const GLint, count: [*c]const GLsizei, drawcount: GLsizei) void;
    const glMultiDrawElements = fn(mode: GLenum, count: [*c]const GLsizei, type: GLenum, indices: [*c]const *const c_void, drawcount: GLsizei) void;
    const glPointParameterf = fn(pname: GLenum, param: GLfloat) void;
    const glPointParameterfv = fn(pname: GLenum, params: [*c]const GLfloat) void;
    const glPointParameteri = fn(pname: GLenum, param: GLint) void;
    const glPointParameteriv = fn(pname: GLenum, params: [*c]const GLint) void;
    const glGetInteger64i_v = fn(target: GLenum, index: GLuint, data: [*c]GLint64) void;
    const glGetSynciv = fn(sync: GLsync, pname: GLenum, count: GLsizei, length: [*c]GLsizei, values: [*c]GLint) void;
    const glGetInteger64v = fn(pname: GLenum, data: [*c]GLint64) void;
    const glWaitSync = fn(sync: GLsync, flags: GLbitfield, timeout: GLuint64) void;
    const glClientWaitSync = fn(sync: GLsync, flags: GLbitfield, timeout: GLuint64) GLenum;
    const glDeleteSync = fn(sync: GLsync) void;
    const glIsSync = fn(sync: GLsync) GLboolean;
    const glFenceSync = fn(condition: GLenum, flags: GLbitfield) GLsync;
    const glBlendColor = fn(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) void;
    const glBlendEquation = fn(mode: GLenum) void;
    const glProvokingVertex = fn(mode: GLenum) void;
    const glMultiDrawElementsBaseVertex = fn(mode: GLenum, count: [*c]const GLsizei, type: GLenum, indices: [*c]const *const c_void, drawcount: GLsizei, basevertex: [*c]const GLint) void;
    const glDrawElementsInstancedBaseVertex = fn(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, instancecount: GLsizei, basevertex: GLint) void;
    const glDrawRangeElementsBaseVertex = fn(mode: GLenum, start: GLuint, end: GLuint, count: GLsizei, type: GLenum, indices: *const c_void, basevertex: GLint) void;
    const glDrawElementsBaseVertex = fn(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, basevertex: GLint) void;
    const glGenQueries = fn(n: GLsizei, ids: [*c]GLuint) void;
    const glDeleteQueries = fn(n: GLsizei, ids: [*c]const GLuint) void;
    const glIsQuery = fn(id: GLuint) GLboolean;
    const glBeginQuery = fn(target: GLenum, id: GLuint) void;
    const glEndQuery = fn(target: GLenum) void;
    const glGetQueryiv = fn(target: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glGetQueryObjectiv = fn(id: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetQueryObjectuiv = fn(id: GLuint, pname: GLenum, params: [*c]GLuint) void;
    const glBindBuffer = fn(target: GLenum, buffer: GLuint) void;
    const glDeleteBuffers = fn(n: GLsizei, buffers: [*c]const GLuint) void;
    const glGenBuffers = fn(n: GLsizei, buffers: [*c]GLuint) void;
    const glIsBuffer = fn(buffer: GLuint) GLboolean;
    const glBufferData = fn(target: GLenum, size: GLsizeiptr, data: *const c_void, usage: GLenum) void;
    const glBufferSubData = fn(target: GLenum, offset: GLintptr, size: GLsizeiptr, data: *const c_void) void;
    const glGetBufferSubData = fn(target: GLenum, offset: GLintptr, size: GLsizeiptr, data: *c_void) void;
    const glMapBuffer = fn(target: GLenum, access: GLenum) *c_void;
    const glUnmapBuffer = fn(target: GLenum) GLboolean;
    const glGetBufferParameteriv = fn(target: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glGetBufferPointerv = fn(target: GLenum, pname: GLenum, params: **c_void) void;
    const glBlendEquationSeparate = fn(modeRGB: GLenum, modeAlpha: GLenum) void;
    const glDrawBuffers = fn(n: GLsizei, bufs: [*c]const GLenum) void;
    const glStencilOpSeparate = fn(face: GLenum, sfail: GLenum, dpfail: GLenum, dppass: GLenum) void;
    const glStencilFuncSeparate = fn(face: GLenum, func: GLenum, ref: GLint, mask: GLuint) void;
    const glStencilMaskSeparate = fn(face: GLenum, mask: GLuint) void;
    const glAttachShader = fn(program: GLuint, shader: GLuint) void;
    const glBindAttribLocation = fn(program: GLuint, index: GLuint, name: [*c]const GLchar) void;
    const glCompileShader = fn(shader: GLuint) void;
    const glCreateProgram = fn() GLuint;
    const glCreateShader = fn(type: GLenum) GLuint;
    const glDeleteProgram = fn(program: GLuint) void;
    const glDeleteShader = fn(shader: GLuint) void;
    const glDetachShader = fn(program: GLuint, shader: GLuint) void;
    const glDisableVertexAttribArray = fn(index: GLuint) void;
    const glEnableVertexAttribArray = fn(index: GLuint) void;
    const glGetActiveAttrib = fn(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLint, type: [*c]GLenum, name: [*c]GLchar) void;
    const glGetActiveUniform = fn(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLint, type: [*c]GLenum, name: [*c]GLchar) void;
    const glGetAttachedShaders = fn(program: GLuint, maxCount: GLsizei, count: [*c]GLsizei, shaders: [*c]GLuint) void;
    const glGetAttribLocation = fn(program: GLuint, name: [*c]const GLchar) GLint;
    const glGetProgramiv = fn(program: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetProgramInfoLog = fn(program: GLuint, bufSize: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) void;
    const glGetShaderiv = fn(shader: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetShaderInfoLog = fn(shader: GLuint, bufSize: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) void;
    const glGetShaderSource = fn(shader: GLuint, bufSize: GLsizei, length: [*c]GLsizei, source: [*c]GLchar) void;
    const glGetUniformLocation = fn(program: GLuint, name: [*c]const GLchar) GLint;
    const glGetUniformfv = fn(program: GLuint, location: GLint, params: [*c]GLfloat) void;
    const glGetUniformiv = fn(program: GLuint, location: GLint, params: [*c]GLint) void;
    const glGetVertexAttribdv = fn(index: GLuint, pname: GLenum, params: [*c]GLdouble) void;
    const glGetVertexAttribfv = fn(index: GLuint, pname: GLenum, params: [*c]GLfloat) void;
    const glGetVertexAttribiv = fn(index: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetVertexAttribPointerv = fn(index: GLuint, pname: GLenum, pointer: **c_void) void;
    const glIsProgram = fn(program: GLuint) GLboolean;
    const glIsShader = fn(shader: GLuint) GLboolean;
    const glLinkProgram = fn(program: GLuint) void;
    const glShaderSource = fn(shader: GLuint, count: GLsizei, string: [*c]const [*c]const GLchar, length: [*c]const GLint) void;
    const glUseProgram = fn(program: GLuint) void;
    const glUniform1f = fn(location: GLint, v0: GLfloat) void;
    const glUniform2f = fn(location: GLint, v0: GLfloat, v1: GLfloat) void;
    const glUniform3f = fn(location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat) void;
    const glUniform4f = fn(location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat, v3: GLfloat) void;
    const glUniform1i = fn(location: GLint, v0: GLint) void;
    const glUniform2i = fn(location: GLint, v0: GLint, v1: GLint) void;
    const glUniform3i = fn(location: GLint, v0: GLint, v1: GLint, v2: GLint) void;
    const glUniform4i = fn(location: GLint, v0: GLint, v1: GLint, v2: GLint, v3: GLint) void;
    const glUniform1fv = fn(location: GLint, count: GLsizei, value: [*c]const GLfloat) void;
    const glUniform2fv = fn(location: GLint, count: GLsizei, value: [*c]const GLfloat) void;
    const glUniform3fv = fn(location: GLint, count: GLsizei, value: [*c]const GLfloat) void;
    const glUniform4fv = fn(location: GLint, count: GLsizei, value: [*c]const GLfloat) void;
    const glUniform1iv = fn(location: GLint, count: GLsizei, value: [*c]const GLint) void;
    const glUniform2iv = fn(location: GLint, count: GLsizei, value: [*c]const GLint) void;
    const glUniform3iv = fn(location: GLint, count: GLsizei, value: [*c]const GLint) void;
    const glUniform4iv = fn(location: GLint, count: GLsizei, value: [*c]const GLint) void;
    const glUniformMatrix2fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix3fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix4fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glValidateProgram = fn(program: GLuint) void;
    const glVertexAttrib1d = fn(index: GLuint, x: GLdouble) void;
    const glVertexAttrib1dv = fn(index: GLuint, v: [*c]const GLdouble) void;
    const glVertexAttrib1f = fn(index: GLuint, x: GLfloat) void;
    const glVertexAttrib1fv = fn(index: GLuint, v: [*c]const GLfloat) void;
    const glVertexAttrib1s = fn(index: GLuint, x: GLshort) void;
    const glVertexAttrib1sv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttrib2d = fn(index: GLuint, x: GLdouble, y: GLdouble) void;
    const glVertexAttrib2dv = fn(index: GLuint, v: [*c]const GLdouble) void;
    const glVertexAttrib2f = fn(index: GLuint, x: GLfloat, y: GLfloat) void;
    const glVertexAttrib2fv = fn(index: GLuint, v: [*c]const GLfloat) void;
    const glVertexAttrib2s = fn(index: GLuint, x: GLshort, y: GLshort) void;
    const glVertexAttrib2sv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttrib3d = fn(index: GLuint, x: GLdouble, y: GLdouble, z: GLdouble) void;
    const glVertexAttrib3dv = fn(index: GLuint, v: [*c]const GLdouble) void;
    const glVertexAttrib3f = fn(index: GLuint, x: GLfloat, y: GLfloat, z: GLfloat) void;
    const glVertexAttrib3fv = fn(index: GLuint, v: [*c]const GLfloat) void;
    const glVertexAttrib3s = fn(index: GLuint, x: GLshort, y: GLshort, z: GLshort) void;
    const glVertexAttrib3sv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttrib4Nbv = fn(index: GLuint, v: [*c]const GLbyte) void;
    const glVertexAttrib4Niv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttrib4Nsv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttrib4Nub = fn(index: GLuint, x: GLubyte, y: GLubyte, z: GLubyte, w: GLubyte) void;
    const glVertexAttrib4Nubv = fn(index: GLuint, v: [*:0]const GLubyte) void;
    const glVertexAttrib4Nuiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttrib4Nusv = fn(index: GLuint, v: [*c]const GLushort) void;
    const glVertexAttrib4bv = fn(index: GLuint, v: [*c]const GLbyte) void;
    const glVertexAttrib4d = fn(index: GLuint, x: GLdouble, y: GLdouble, z: GLdouble, w: GLdouble) void;
    const glVertexAttrib4dv = fn(index: GLuint, v: [*c]const GLdouble) void;
    const glVertexAttrib4f = fn(index: GLuint, x: GLfloat, y: GLfloat, z: GLfloat, w: GLfloat) void;
    const glVertexAttrib4fv = fn(index: GLuint, v: [*c]const GLfloat) void;
    const glVertexAttrib4iv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttrib4s = fn(index: GLuint, x: GLshort, y: GLshort, z: GLshort, w: GLshort) void;
    const glVertexAttrib4sv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttrib4ubv = fn(index: GLuint, v: [*:0]const GLubyte) void;
    const glVertexAttrib4uiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttrib4usv = fn(index: GLuint, v: [*c]const GLushort) void;
    const glVertexAttribPointer = fn(index: GLuint, size: GLint, type: GLenum, normalized: GLboolean, stride: GLsizei, pointer: *const c_void) void;
    const glUniformMatrix2x3fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix3x2fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix2x4fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix4x2fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix3x4fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glUniformMatrix4x3fv = fn(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void;
    const glColorMaski = fn(index: GLuint, r: GLboolean, g: GLboolean, b: GLboolean, a: GLboolean) void;
    const glGetBooleani_v = fn(target: GLenum, index: GLuint, data: [*c]GLboolean) void;
    const glGetIntegeri_v = fn(target: GLenum, index: GLuint, data: [*c]GLint) void;
    const glEnablei = fn(target: GLenum, index: GLuint) void;
    const glDisablei = fn(target: GLenum, index: GLuint) void;
    const glIsEnabledi = fn(target: GLenum, index: GLuint) GLboolean;
    const glBeginTransformFeedback = fn(primitiveMode: GLenum) void;
    const glEndTransformFeedback = fn() void;
    const glBindBufferRange = fn(target: GLenum, index: GLuint, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void;
    const glBindBufferBase = fn(target: GLenum, index: GLuint, buffer: GLuint) void;
    const glTransformFeedbackVaryings = fn(program: GLuint, count: GLsizei, varyings: [*c]const [*c]const GLchar, bufferMode: GLenum) void;
    const glGetTransformFeedbackVarying = fn(program: GLuint, index: GLuint, bufSize: GLsizei, length: [*c]GLsizei, size: [*c]GLsizei, type: [*c]GLenum, name: [*c]GLchar) void;
    const glClampColor = fn(target: GLenum, clamp: GLenum) void;
    const glBeginConditionalRender = fn(id: GLuint, mode: GLenum) void;
    const glEndConditionalRender = fn() void;
    const glVertexAttribIPointer = fn(index: GLuint, size: GLint, type: GLenum, stride: GLsizei, pointer: *const c_void) void;
    const glGetVertexAttribIiv = fn(index: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetVertexAttribIuiv = fn(index: GLuint, pname: GLenum, params: [*c]GLuint) void;
    const glVertexAttribI1i = fn(index: GLuint, x: GLint) void;
    const glVertexAttribI2i = fn(index: GLuint, x: GLint, y: GLint) void;
    const glVertexAttribI3i = fn(index: GLuint, x: GLint, y: GLint, z: GLint) void;
    const glVertexAttribI4i = fn(index: GLuint, x: GLint, y: GLint, z: GLint, w: GLint) void;
    const glVertexAttribI1ui = fn(index: GLuint, x: GLuint) void;
    const glVertexAttribI2ui = fn(index: GLuint, x: GLuint, y: GLuint) void;
    const glVertexAttribI3ui = fn(index: GLuint, x: GLuint, y: GLuint, z: GLuint) void;
    const glVertexAttribI4ui = fn(index: GLuint, x: GLuint, y: GLuint, z: GLuint, w: GLuint) void;
    const glVertexAttribI1iv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttribI2iv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttribI3iv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttribI4iv = fn(index: GLuint, v: [*c]const GLint) void;
    const glVertexAttribI1uiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttribI2uiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttribI3uiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttribI4uiv = fn(index: GLuint, v: [*c]const GLuint) void;
    const glVertexAttribI4bv = fn(index: GLuint, v: [*c]const GLbyte) void;
    const glVertexAttribI4sv = fn(index: GLuint, v: [*c]const GLshort) void;
    const glVertexAttribI4ubv = fn(index: GLuint, v: [*:0]const GLubyte) void;
    const glVertexAttribI4usv = fn(index: GLuint, v: [*c]const GLushort) void;
    const glGetUniformuiv = fn(program: GLuint, location: GLint, params: [*c]GLuint) void;
    const glBindFragDataLocation = fn(program: GLuint, color: GLuint, name: [*c]const GLchar) void;
    const glGetFragDataLocation = fn(program: GLuint, name: [*c]const GLchar) GLint;
    const glUniform1ui = fn(location: GLint, v0: GLuint) void;
    const glUniform2ui = fn(location: GLint, v0: GLuint, v1: GLuint) void;
    const glUniform3ui = fn(location: GLint, v0: GLuint, v1: GLuint, v2: GLuint) void;
    const glUniform4ui = fn(location: GLint, v0: GLuint, v1: GLuint, v2: GLuint, v3: GLuint) void;
    const glUniform1uiv = fn(location: GLint, count: GLsizei, value: [*c]const GLuint) void;
    const glUniform2uiv = fn(location: GLint, count: GLsizei, value: [*c]const GLuint) void;
    const glUniform3uiv = fn(location: GLint, count: GLsizei, value: [*c]const GLuint) void;
    const glUniform4uiv = fn(location: GLint, count: GLsizei, value: [*c]const GLuint) void;
    const glTexParameterIiv = fn(target: GLenum, pname: GLenum, params: [*c]const GLint) void;
    const glTexParameterIuiv = fn(target: GLenum, pname: GLenum, params: [*c]const GLuint) void;
    const glGetTexParameterIiv = fn(target: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glGetTexParameterIuiv = fn(target: GLenum, pname: GLenum, params: [*c]GLuint) void;
    const glClearBufferiv = fn(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLint) void;
    const glClearBufferuiv = fn(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLuint) void;
    const glClearBufferfv = fn(buffer: GLenum, drawbuffer: GLint, value: [*c]const GLfloat) void;
    const glClearBufferfi = fn(buffer: GLenum, drawbuffer: GLint, depth: GLfloat, stencil: GLint) void;
    const glGetStringi = fn(name: GLenum, index: GLuint) [*:0]const GLubyte;
    const glIsRenderbuffer = fn(renderbuffer: GLuint) GLboolean;
    const glBindRenderbuffer = fn(target: GLenum, renderbuffer: GLuint) void;
    const glDeleteRenderbuffers = fn(n: GLsizei, renderbuffers: [*c]const GLuint) void;
    const glGenRenderbuffers = fn(n: GLsizei, renderbuffers: [*c]GLuint) void;
    const glRenderbufferStorage = fn(target: GLenum, internalformat: GLenum, width: GLsizei, height: GLsizei) void;
    const glGetRenderbufferParameteriv = fn(target: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glIsFramebuffer = fn(framebuffer: GLuint) GLboolean;
    const glBindFramebuffer = fn(target: GLenum, framebuffer: GLuint) void;
    const glDeleteFramebuffers = fn(n: GLsizei, framebuffers: [*c]const GLuint) void;
    const glGenFramebuffers = fn(n: GLsizei, framebuffers: [*c]GLuint) void;
    const glCheckFramebufferStatus = fn(target: GLenum) GLenum;
    const glFramebufferTexture1D = fn(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint) void;
    const glFramebufferTexture2D = fn(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint) void;
    const glFramebufferTexture3D = fn(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint, zoffset: GLint) void;
    const glFramebufferRenderbuffer = fn(target: GLenum, attachment: GLenum, renderbuffertarget: GLenum, renderbuffer: GLuint) void;
    const glGetFramebufferAttachmentParameteriv = fn(target: GLenum, attachment: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glGenerateMipmap = fn(target: GLenum) void;
    const glBlitFramebuffer = fn(srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum) void;
    const glRenderbufferStorageMultisample = fn(target: GLenum, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void;
    const glFramebufferTextureLayer = fn(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint, layer: GLint) void;
    const glMapBufferRange = fn(target: GLenum, offset: GLintptr, length: GLsizeiptr, access: GLbitfield) *c_void;
    const glFlushMappedBufferRange = fn(target: GLenum, offset: GLintptr, length: GLsizeiptr) void;
    const glBindVertexArray = fn(array: GLuint) void;
    const glDeleteVertexArrays = fn(n: GLsizei, arrays: [*c]const GLuint) void;
    const glGenVertexArrays = fn(n: GLsizei, arrays: [*c]GLuint) void;
    const glIsVertexArray = fn(array: GLuint) GLboolean;
    const glDrawArraysInstanced = fn(mode: GLenum, first: GLint, count: GLsizei, instancecount: GLsizei) void;
    const glDrawElementsInstanced = fn(mode: GLenum, count: GLsizei, type: GLenum, indices: *const c_void, instancecount: GLsizei) void;
    const glTexBuffer = fn(target: GLenum, internalformat: GLenum, buffer: GLuint) void;
    const glPrimitiveRestartIndex = fn(index: GLuint) void;
    const glCopyBufferSubData = fn(readTarget: GLenum, writeTarget: GLenum, readOffset: GLintptr, writeOffset: GLintptr, size: GLsizeiptr) void;
    const glGetUniformIndices = fn(program: GLuint, uniformCount: GLsizei, uniformNames: [*c]const [*c]const GLchar, uniformIndices: [*c]GLuint) void;
    const glGetActiveUniformsiv = fn(program: GLuint, uniformCount: GLsizei, uniformIndices: [*c]const GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetActiveUniformName = fn(program: GLuint, uniformIndex: GLuint, bufSize: GLsizei, length: [*c]GLsizei, uniformName: [*c]GLchar) void;
    const glGetUniformBlockIndex = fn(program: GLuint, uniformBlockName: [*c]const GLchar) GLuint;
    const glGetActiveUniformBlockiv = fn(program: GLuint, uniformBlockIndex: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetActiveUniformBlockName = fn(program: GLuint, uniformBlockIndex: GLuint, bufSize: GLsizei, length: [*c]GLsizei, uniformBlockName: [*c]GLchar) void;
    const glUniformBlockBinding = fn(program: GLuint, uniformBlockIndex: GLuint, uniformBlockBinding: GLuint) void;
    const glCreateTransformFeedbacks = fn(n: GLsizei, ids: [*c]GLuint) void;
    const glTransformFeedbackBufferBase = fn(xfb: GLuint, index: GLuint, buffer: GLuint) void;
    const glTransformFeedbackBufferRange = fn(xfb: GLuint, index: GLuint, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void;
    const glGetTransformFeedbackiv = fn(xfb: GLuint, pname: GLenum, param: [*c]GLint) void;
    const glGetTransformFeedbacki_v = fn(xfb: GLuint, pname: GLenum, index: GLuint, param: [*c]GLint) void;
    const glGetTransformFeedbacki64_v = fn(xfb: GLuint, pname: GLenum, index: GLuint, param: [*c]GLint64) void;
    const glCreateBuffers = fn(n: GLsizei, buffers: [*c]GLuint) void;
    const glNamedBufferStorage = fn(buffer: GLuint, size: GLsizeiptr, data: *const c_void, flags: GLbitfield) void;
    const glNamedBufferData = fn(buffer: GLuint, size: GLsizeiptr, data: *const c_void, usage: GLenum) void;
    const glNamedBufferSubData = fn(buffer: GLuint, offset: GLintptr, size: GLsizeiptr, data: *const c_void) void;
    const glCopyNamedBufferSubData = fn(readBuffer: GLuint, writeBuffer: GLuint, readOffset: GLintptr, writeOffset: GLintptr, size: GLsizeiptr) void;
    const glClearNamedBufferData = fn(buffer: GLuint, internalformat: GLenum, format: GLenum, type: GLenum, data: *const c_void) void;
    const glClearNamedBufferSubData = fn(buffer: GLuint, internalformat: GLenum, offset: GLintptr, size: GLsizeiptr, format: GLenum, type: GLenum, data: *const c_void) void;
    const glMapNamedBuffer = fn(buffer: GLuint, access: GLenum) *c_void;
    const glMapNamedBufferRange = fn(buffer: GLuint, offset: GLintptr, length: GLsizeiptr, access: GLbitfield) *c_void;
    const glUnmapNamedBuffer = fn(buffer: GLuint) GLboolean;
    const glFlushMappedNamedBufferRange = fn(buffer: GLuint, offset: GLintptr, length: GLsizeiptr) void;
    const glGetNamedBufferParameteriv = fn(buffer: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetNamedBufferParameteri64v = fn(buffer: GLuint, pname: GLenum, params: [*c]GLint64) void;
    const glGetNamedBufferPointerv = fn(buffer: GLuint, pname: GLenum, params: **c_void) void;
    const glGetNamedBufferSubData = fn(buffer: GLuint, offset: GLintptr, size: GLsizeiptr, data: *c_void) void;
    const glCreateFramebuffers = fn(n: GLsizei, framebuffers: [*c]GLuint) void;
    const glNamedFramebufferRenderbuffer = fn(framebuffer: GLuint, attachment: GLenum, renderbuffertarget: GLenum, renderbuffer: GLuint) void;
    const glNamedFramebufferParameteri = fn(framebuffer: GLuint, pname: GLenum, param: GLint) void;
    const glNamedFramebufferTexture = fn(framebuffer: GLuint, attachment: GLenum, texture: GLuint, level: GLint) void;
    const glNamedFramebufferTextureLayer = fn(framebuffer: GLuint, attachment: GLenum, texture: GLuint, level: GLint, layer: GLint) void;
    const glNamedFramebufferDrawBuffer = fn(framebuffer: GLuint, buf: GLenum) void;
    const glNamedFramebufferDrawBuffers = fn(framebuffer: GLuint, n: GLsizei, bufs: [*c]const GLenum) void;
    const glNamedFramebufferReadBuffer = fn(framebuffer: GLuint, src: GLenum) void;
    const glInvalidateNamedFramebufferData = fn(framebuffer: GLuint, numAttachments: GLsizei, attachments: [*c]const GLenum) void;
    const glInvalidateNamedFramebufferSubData = fn(framebuffer: GLuint, numAttachments: GLsizei, attachments: [*c]const GLenum, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glClearNamedFramebufferiv = fn(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLint) void;
    const glClearNamedFramebufferuiv = fn(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLuint) void;
    const glClearNamedFramebufferfv = fn(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, value: [*c]const GLfloat) void;
    const glClearNamedFramebufferfi = fn(framebuffer: GLuint, buffer: GLenum, drawbuffer: GLint, depth: GLfloat, stencil: GLint) void;
    const glBlitNamedFramebuffer = fn(readFramebuffer: GLuint, drawFramebuffer: GLuint, srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum) void;
    const glCheckNamedFramebufferStatus = fn(framebuffer: GLuint, target: GLenum) GLenum;
    const glGetNamedFramebufferParameteriv = fn(framebuffer: GLuint, pname: GLenum, param: [*c]GLint) void;
    const glGetNamedFramebufferAttachmentParameteriv = fn(framebuffer: GLuint, attachment: GLenum, pname: GLenum, params: [*c]GLint) void;
    const glCreateRenderbuffers = fn(n: GLsizei, renderbuffers: [*c]GLuint) void;
    const glNamedRenderbufferStorage = fn(renderbuffer: GLuint, internalformat: GLenum, width: GLsizei, height: GLsizei) void;
    const glNamedRenderbufferStorageMultisample = fn(renderbuffer: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void;
    const glGetNamedRenderbufferParameteriv = fn(renderbuffer: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glCreateTextures = fn(target: GLenum, n: GLsizei, textures: [*c]GLuint) void;
    const glTextureBuffer = fn(texture: GLuint, internalformat: GLenum, buffer: GLuint) void;
    const glTextureBufferRange = fn(texture: GLuint, internalformat: GLenum, buffer: GLuint, offset: GLintptr, size: GLsizeiptr) void;
    const glTextureStorage1D = fn(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei) void;
    const glTextureStorage2D = fn(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei) void;
    const glTextureStorage3D = fn(texture: GLuint, levels: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei) void;
    const glTextureStorage2DMultisample = fn(texture: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, fixedsamplelocations: GLboolean) void;
    const glTextureStorage3DMultisample = fn(texture: GLuint, samples: GLsizei, internalformat: GLenum, width: GLsizei, height: GLsizei, depth: GLsizei, fixedsamplelocations: GLboolean) void;
    const glTextureSubImage1D = fn(texture: GLuint, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glTextureSubImage2D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glTextureSubImage3D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, type: GLenum, pixels: *const c_void) void;
    const glCompressedTextureSubImage1D = fn(texture: GLuint, level: GLint, xoffset: GLint, width: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTextureSubImage2D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, width: GLsizei, height: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glCompressedTextureSubImage3D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, width: GLsizei, height: GLsizei, depth: GLsizei, format: GLenum, imageSize: GLsizei, data: *const c_void) void;
    const glCopyTextureSubImage1D = fn(texture: GLuint, level: GLint, xoffset: GLint, x: GLint, y: GLint, width: GLsizei) void;
    const glCopyTextureSubImage2D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glCopyTextureSubImage3D = fn(texture: GLuint, level: GLint, xoffset: GLint, yoffset: GLint, zoffset: GLint, x: GLint, y: GLint, width: GLsizei, height: GLsizei) void;
    const glTextureParameterf = fn(texture: GLuint, pname: GLenum, param: GLfloat) void;
    const glTextureParameterfv = fn(texture: GLuint, pname: GLenum, param: [*c]const GLfloat) void;
    const glTextureParameteri = fn(texture: GLuint, pname: GLenum, param: GLint) void;
    const glTextureParameterIiv = fn(texture: GLuint, pname: GLenum, params: [*c]const GLint) void;
    const glTextureParameterIuiv = fn(texture: GLuint, pname: GLenum, params: [*c]const GLuint) void;
    const glTextureParameteriv = fn(texture: GLuint, pname: GLenum, param: [*c]const GLint) void;
    const glGenerateTextureMipmap = fn(texture: GLuint) void;
    const glBindTextureUnit = fn(unit: GLuint, texture: GLuint) void;
    const glGetTextureImage = fn(texture: GLuint, level: GLint, format: GLenum, type: GLenum, bufSize: GLsizei, pixels: *c_void) void;
    const glGetCompressedTextureImage = fn(texture: GLuint, level: GLint, bufSize: GLsizei, pixels: *c_void) void;
    const glGetTextureLevelParameterfv = fn(texture: GLuint, level: GLint, pname: GLenum, params: [*c]GLfloat) void;
    const glGetTextureLevelParameteriv = fn(texture: GLuint, level: GLint, pname: GLenum, params: [*c]GLint) void;
    const glGetTextureParameterfv = fn(texture: GLuint, pname: GLenum, params: [*c]GLfloat) void;
    const glGetTextureParameterIiv = fn(texture: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glGetTextureParameterIuiv = fn(texture: GLuint, pname: GLenum, params: [*c]GLuint) void;
    const glGetTextureParameteriv = fn(texture: GLuint, pname: GLenum, params: [*c]GLint) void;
    const glCreateVertexArrays = fn(n: GLsizei, arrays: [*c]GLuint) void;
    const glDisableVertexArrayAttrib = fn(vaobj: GLuint, index: GLuint) void;
    const glEnableVertexArrayAttrib = fn(vaobj: GLuint, index: GLuint) void;
    const glVertexArrayElementBuffer = fn(vaobj: GLuint, buffer: GLuint) void;
    const glVertexArrayVertexBuffer = fn(vaobj: GLuint, bindingindex: GLuint, buffer: GLuint, offset: GLintptr, stride: GLsizei) void;
    const glVertexArrayVertexBuffers = fn(vaobj: GLuint, first: GLuint, count: GLsizei, buffers: [*c]const GLuint, offsets: [*c]const GLintptr, strides: [*c]const GLsizei) void;
    const glVertexArrayAttribBinding = fn(vaobj: GLuint, attribindex: GLuint, bindingindex: GLuint) void;
    const glVertexArrayAttribFormat = fn(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, normalized: GLboolean, relativeoffset: GLuint) void;
    const glVertexArrayAttribIFormat = fn(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, relativeoffset: GLuint) void;
    const glVertexArrayAttribLFormat = fn(vaobj: GLuint, attribindex: GLuint, size: GLint, type: GLenum, relativeoffset: GLuint) void;
    const glVertexArrayBindingDivisor = fn(vaobj: GLuint, bindingindex: GLuint, divisor: GLuint) void;
    const glGetVertexArrayiv = fn(vaobj: GLuint, pname: GLenum, param: [*c]GLint) void;
    const glGetVertexArrayIndexediv = fn(vaobj: GLuint, index: GLuint, pname: GLenum, param: [*c]GLint) void;
    const glGetVertexArrayIndexed64iv = fn(vaobj: GLuint, index: GLuint, pname: GLenum, param: [*c]GLint64) void;
    const glCreateSamplers = fn(n: GLsizei, samplers: [*c]GLuint) void;
    const glCreateProgramPipelines = fn(n: GLsizei, pipelines: [*c]GLuint) void;
    const glCreateQueries = fn(target: GLenum, n: GLsizei, ids: [*c]GLuint) void;
    const glGetQueryBufferObjecti64v = fn(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void;
    const glGetQueryBufferObjectiv = fn(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void;
    const glGetQueryBufferObjectui64v = fn(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void;
    const glGetQueryBufferObjectuiv = fn(id: GLuint, buffer: GLuint, pname: GLenum, offset: GLintptr) void;
};

const function_pointers = struct {
    var glCullFace: ?function_signatures.glCullFace = null;
    var glFrontFace: ?function_signatures.glFrontFace = null;
    var glHint: ?function_signatures.glHint = null;
    var glLineWidth: ?function_signatures.glLineWidth = null;
    var glPointSize: ?function_signatures.glPointSize = null;
    var glPolygonMode: ?function_signatures.glPolygonMode = null;
    var glScissor: ?function_signatures.glScissor = null;
    var glTexParameterf: ?function_signatures.glTexParameterf = null;
    var glTexParameterfv: ?function_signatures.glTexParameterfv = null;
    var glTexParameteri: ?function_signatures.glTexParameteri = null;
    var glTexParameteriv: ?function_signatures.glTexParameteriv = null;
    var glTexImage1D: ?function_signatures.glTexImage1D = null;
    var glTexImage2D: ?function_signatures.glTexImage2D = null;
    var glDrawBuffer: ?function_signatures.glDrawBuffer = null;
    var glClear: ?function_signatures.glClear = null;
    var glClearColor: ?function_signatures.glClearColor = null;
    var glClearStencil: ?function_signatures.glClearStencil = null;
    var glClearDepth: ?function_signatures.glClearDepth = null;
    var glStencilMask: ?function_signatures.glStencilMask = null;
    var glColorMask: ?function_signatures.glColorMask = null;
    var glDepthMask: ?function_signatures.glDepthMask = null;
    var glDisable: ?function_signatures.glDisable = null;
    var glEnable: ?function_signatures.glEnable = null;
    var glFinish: ?function_signatures.glFinish = null;
    var glFlush: ?function_signatures.glFlush = null;
    var glBlendFunc: ?function_signatures.glBlendFunc = null;
    var glLogicOp: ?function_signatures.glLogicOp = null;
    var glStencilFunc: ?function_signatures.glStencilFunc = null;
    var glStencilOp: ?function_signatures.glStencilOp = null;
    var glDepthFunc: ?function_signatures.glDepthFunc = null;
    var glPixelStoref: ?function_signatures.glPixelStoref = null;
    var glPixelStorei: ?function_signatures.glPixelStorei = null;
    var glReadBuffer: ?function_signatures.glReadBuffer = null;
    var glReadPixels: ?function_signatures.glReadPixels = null;
    var glGetBooleanv: ?function_signatures.glGetBooleanv = null;
    var glGetDoublev: ?function_signatures.glGetDoublev = null;
    var glGetError: ?function_signatures.glGetError = null;
    var glGetFloatv: ?function_signatures.glGetFloatv = null;
    var glGetIntegerv: ?function_signatures.glGetIntegerv = null;
    var glGetString: ?function_signatures.glGetString = null;
    var glGetTexImage: ?function_signatures.glGetTexImage = null;
    var glGetTexParameterfv: ?function_signatures.glGetTexParameterfv = null;
    var glGetTexParameteriv: ?function_signatures.glGetTexParameteriv = null;
    var glGetTexLevelParameterfv: ?function_signatures.glGetTexLevelParameterfv = null;
    var glGetTexLevelParameteriv: ?function_signatures.glGetTexLevelParameteriv = null;
    var glIsEnabled: ?function_signatures.glIsEnabled = null;
    var glDepthRange: ?function_signatures.glDepthRange = null;
    var glViewport: ?function_signatures.glViewport = null;
    var glDrawArrays: ?function_signatures.glDrawArrays = null;
    var glDrawElements: ?function_signatures.glDrawElements = null;
    var glPolygonOffset: ?function_signatures.glPolygonOffset = null;
    var glCopyTexImage1D: ?function_signatures.glCopyTexImage1D = null;
    var glCopyTexImage2D: ?function_signatures.glCopyTexImage2D = null;
    var glCopyTexSubImage1D: ?function_signatures.glCopyTexSubImage1D = null;
    var glCopyTexSubImage2D: ?function_signatures.glCopyTexSubImage2D = null;
    var glTexSubImage1D: ?function_signatures.glTexSubImage1D = null;
    var glTexSubImage2D: ?function_signatures.glTexSubImage2D = null;
    var glBindTexture: ?function_signatures.glBindTexture = null;
    var glDeleteTextures: ?function_signatures.glDeleteTextures = null;
    var glGenTextures: ?function_signatures.glGenTextures = null;
    var glIsTexture: ?function_signatures.glIsTexture = null;
    var glDrawRangeElements: ?function_signatures.glDrawRangeElements = null;
    var glTexImage3D: ?function_signatures.glTexImage3D = null;
    var glTexSubImage3D: ?function_signatures.glTexSubImage3D = null;
    var glCopyTexSubImage3D: ?function_signatures.glCopyTexSubImage3D = null;
    var glSecondaryColorP3uiv: ?function_signatures.glSecondaryColorP3uiv = null;
    var glSecondaryColorP3ui: ?function_signatures.glSecondaryColorP3ui = null;
    var glColorP4uiv: ?function_signatures.glColorP4uiv = null;
    var glColorP4ui: ?function_signatures.glColorP4ui = null;
    var glColorP3uiv: ?function_signatures.glColorP3uiv = null;
    var glColorP3ui: ?function_signatures.glColorP3ui = null;
    var glNormalP3uiv: ?function_signatures.glNormalP3uiv = null;
    var glNormalP3ui: ?function_signatures.glNormalP3ui = null;
    var glMultiTexCoordP4uiv: ?function_signatures.glMultiTexCoordP4uiv = null;
    var glMultiTexCoordP4ui: ?function_signatures.glMultiTexCoordP4ui = null;
    var glMultiTexCoordP3uiv: ?function_signatures.glMultiTexCoordP3uiv = null;
    var glMultiTexCoordP3ui: ?function_signatures.glMultiTexCoordP3ui = null;
    var glMultiTexCoordP2uiv: ?function_signatures.glMultiTexCoordP2uiv = null;
    var glMultiTexCoordP2ui: ?function_signatures.glMultiTexCoordP2ui = null;
    var glMultiTexCoordP1uiv: ?function_signatures.glMultiTexCoordP1uiv = null;
    var glMultiTexCoordP1ui: ?function_signatures.glMultiTexCoordP1ui = null;
    var glTexCoordP4uiv: ?function_signatures.glTexCoordP4uiv = null;
    var glTexCoordP4ui: ?function_signatures.glTexCoordP4ui = null;
    var glTexCoordP3uiv: ?function_signatures.glTexCoordP3uiv = null;
    var glTexCoordP3ui: ?function_signatures.glTexCoordP3ui = null;
    var glActiveTexture: ?function_signatures.glActiveTexture = null;
    var glSampleCoverage: ?function_signatures.glSampleCoverage = null;
    var glCompressedTexImage3D: ?function_signatures.glCompressedTexImage3D = null;
    var glCompressedTexImage2D: ?function_signatures.glCompressedTexImage2D = null;
    var glCompressedTexImage1D: ?function_signatures.glCompressedTexImage1D = null;
    var glCompressedTexSubImage3D: ?function_signatures.glCompressedTexSubImage3D = null;
    var glCompressedTexSubImage2D: ?function_signatures.glCompressedTexSubImage2D = null;
    var glCompressedTexSubImage1D: ?function_signatures.glCompressedTexSubImage1D = null;
    var glGetCompressedTexImage: ?function_signatures.glGetCompressedTexImage = null;
    var glTexCoordP2uiv: ?function_signatures.glTexCoordP2uiv = null;
    var glTexCoordP2ui: ?function_signatures.glTexCoordP2ui = null;
    var glTexCoordP1uiv: ?function_signatures.glTexCoordP1uiv = null;
    var glTexCoordP1ui: ?function_signatures.glTexCoordP1ui = null;
    var glVertexP4uiv: ?function_signatures.glVertexP4uiv = null;
    var glVertexP4ui: ?function_signatures.glVertexP4ui = null;
    var glVertexP3uiv: ?function_signatures.glVertexP3uiv = null;
    var glVertexP3ui: ?function_signatures.glVertexP3ui = null;
    var glVertexP2uiv: ?function_signatures.glVertexP2uiv = null;
    var glVertexP2ui: ?function_signatures.glVertexP2ui = null;
    var glVertexAttribP4uiv: ?function_signatures.glVertexAttribP4uiv = null;
    var glVertexAttribP4ui: ?function_signatures.glVertexAttribP4ui = null;
    var glVertexAttribP3uiv: ?function_signatures.glVertexAttribP3uiv = null;
    var glVertexAttribP3ui: ?function_signatures.glVertexAttribP3ui = null;
    var glVertexAttribP2uiv: ?function_signatures.glVertexAttribP2uiv = null;
    var glVertexAttribP2ui: ?function_signatures.glVertexAttribP2ui = null;
    var glVertexAttribP1uiv: ?function_signatures.glVertexAttribP1uiv = null;
    var glVertexAttribP1ui: ?function_signatures.glVertexAttribP1ui = null;
    var glVertexAttribDivisor: ?function_signatures.glVertexAttribDivisor = null;
    var glGetQueryObjectui64v: ?function_signatures.glGetQueryObjectui64v = null;
    var glGetQueryObjecti64v: ?function_signatures.glGetQueryObjecti64v = null;
    var glQueryCounter: ?function_signatures.glQueryCounter = null;
    var glGetSamplerParameterIuiv: ?function_signatures.glGetSamplerParameterIuiv = null;
    var glGetSamplerParameterfv: ?function_signatures.glGetSamplerParameterfv = null;
    var glGetSamplerParameterIiv: ?function_signatures.glGetSamplerParameterIiv = null;
    var glGetSamplerParameteriv: ?function_signatures.glGetSamplerParameteriv = null;
    var glSamplerParameterIuiv: ?function_signatures.glSamplerParameterIuiv = null;
    var glSamplerParameterIiv: ?function_signatures.glSamplerParameterIiv = null;
    var glSamplerParameterfv: ?function_signatures.glSamplerParameterfv = null;
    var glSamplerParameterf: ?function_signatures.glSamplerParameterf = null;
    var glSamplerParameteriv: ?function_signatures.glSamplerParameteriv = null;
    var glSamplerParameteri: ?function_signatures.glSamplerParameteri = null;
    var glBindSampler: ?function_signatures.glBindSampler = null;
    var glIsSampler: ?function_signatures.glIsSampler = null;
    var glDeleteSamplers: ?function_signatures.glDeleteSamplers = null;
    var glGenSamplers: ?function_signatures.glGenSamplers = null;
    var glGetFragDataIndex: ?function_signatures.glGetFragDataIndex = null;
    var glBindFragDataLocationIndexed: ?function_signatures.glBindFragDataLocationIndexed = null;
    var glSampleMaski: ?function_signatures.glSampleMaski = null;
    var glGetMultisamplefv: ?function_signatures.glGetMultisamplefv = null;
    var glTexImage3DMultisample: ?function_signatures.glTexImage3DMultisample = null;
    var glTexImage2DMultisample: ?function_signatures.glTexImage2DMultisample = null;
    var glFramebufferTexture: ?function_signatures.glFramebufferTexture = null;
    var glGetBufferParameteri64v: ?function_signatures.glGetBufferParameteri64v = null;
    var glBlendFuncSeparate: ?function_signatures.glBlendFuncSeparate = null;
    var glMultiDrawArrays: ?function_signatures.glMultiDrawArrays = null;
    var glMultiDrawElements: ?function_signatures.glMultiDrawElements = null;
    var glPointParameterf: ?function_signatures.glPointParameterf = null;
    var glPointParameterfv: ?function_signatures.glPointParameterfv = null;
    var glPointParameteri: ?function_signatures.glPointParameteri = null;
    var glPointParameteriv: ?function_signatures.glPointParameteriv = null;
    var glGetInteger64i_v: ?function_signatures.glGetInteger64i_v = null;
    var glGetSynciv: ?function_signatures.glGetSynciv = null;
    var glGetInteger64v: ?function_signatures.glGetInteger64v = null;
    var glWaitSync: ?function_signatures.glWaitSync = null;
    var glClientWaitSync: ?function_signatures.glClientWaitSync = null;
    var glDeleteSync: ?function_signatures.glDeleteSync = null;
    var glIsSync: ?function_signatures.glIsSync = null;
    var glFenceSync: ?function_signatures.glFenceSync = null;
    var glBlendColor: ?function_signatures.glBlendColor = null;
    var glBlendEquation: ?function_signatures.glBlendEquation = null;
    var glProvokingVertex: ?function_signatures.glProvokingVertex = null;
    var glMultiDrawElementsBaseVertex: ?function_signatures.glMultiDrawElementsBaseVertex = null;
    var glDrawElementsInstancedBaseVertex: ?function_signatures.glDrawElementsInstancedBaseVertex = null;
    var glDrawRangeElementsBaseVertex: ?function_signatures.glDrawRangeElementsBaseVertex = null;
    var glDrawElementsBaseVertex: ?function_signatures.glDrawElementsBaseVertex = null;
    var glGenQueries: ?function_signatures.glGenQueries = null;
    var glDeleteQueries: ?function_signatures.glDeleteQueries = null;
    var glIsQuery: ?function_signatures.glIsQuery = null;
    var glBeginQuery: ?function_signatures.glBeginQuery = null;
    var glEndQuery: ?function_signatures.glEndQuery = null;
    var glGetQueryiv: ?function_signatures.glGetQueryiv = null;
    var glGetQueryObjectiv: ?function_signatures.glGetQueryObjectiv = null;
    var glGetQueryObjectuiv: ?function_signatures.glGetQueryObjectuiv = null;
    var glBindBuffer: ?function_signatures.glBindBuffer = null;
    var glDeleteBuffers: ?function_signatures.glDeleteBuffers = null;
    var glGenBuffers: ?function_signatures.glGenBuffers = null;
    var glIsBuffer: ?function_signatures.glIsBuffer = null;
    var glBufferData: ?function_signatures.glBufferData = null;
    var glBufferSubData: ?function_signatures.glBufferSubData = null;
    var glGetBufferSubData: ?function_signatures.glGetBufferSubData = null;
    var glMapBuffer: ?function_signatures.glMapBuffer = null;
    var glUnmapBuffer: ?function_signatures.glUnmapBuffer = null;
    var glGetBufferParameteriv: ?function_signatures.glGetBufferParameteriv = null;
    var glGetBufferPointerv: ?function_signatures.glGetBufferPointerv = null;
    var glBlendEquationSeparate: ?function_signatures.glBlendEquationSeparate = null;
    var glDrawBuffers: ?function_signatures.glDrawBuffers = null;
    var glStencilOpSeparate: ?function_signatures.glStencilOpSeparate = null;
    var glStencilFuncSeparate: ?function_signatures.glStencilFuncSeparate = null;
    var glStencilMaskSeparate: ?function_signatures.glStencilMaskSeparate = null;
    var glAttachShader: ?function_signatures.glAttachShader = null;
    var glBindAttribLocation: ?function_signatures.glBindAttribLocation = null;
    var glCompileShader: ?function_signatures.glCompileShader = null;
    var glCreateProgram: ?function_signatures.glCreateProgram = null;
    var glCreateShader: ?function_signatures.glCreateShader = null;
    var glDeleteProgram: ?function_signatures.glDeleteProgram = null;
    var glDeleteShader: ?function_signatures.glDeleteShader = null;
    var glDetachShader: ?function_signatures.glDetachShader = null;
    var glDisableVertexAttribArray: ?function_signatures.glDisableVertexAttribArray = null;
    var glEnableVertexAttribArray: ?function_signatures.glEnableVertexAttribArray = null;
    var glGetActiveAttrib: ?function_signatures.glGetActiveAttrib = null;
    var glGetActiveUniform: ?function_signatures.glGetActiveUniform = null;
    var glGetAttachedShaders: ?function_signatures.glGetAttachedShaders = null;
    var glGetAttribLocation: ?function_signatures.glGetAttribLocation = null;
    var glGetProgramiv: ?function_signatures.glGetProgramiv = null;
    var glGetProgramInfoLog: ?function_signatures.glGetProgramInfoLog = null;
    var glGetShaderiv: ?function_signatures.glGetShaderiv = null;
    var glGetShaderInfoLog: ?function_signatures.glGetShaderInfoLog = null;
    var glGetShaderSource: ?function_signatures.glGetShaderSource = null;
    var glGetUniformLocation: ?function_signatures.glGetUniformLocation = null;
    var glGetUniformfv: ?function_signatures.glGetUniformfv = null;
    var glGetUniformiv: ?function_signatures.glGetUniformiv = null;
    var glGetVertexAttribdv: ?function_signatures.glGetVertexAttribdv = null;
    var glGetVertexAttribfv: ?function_signatures.glGetVertexAttribfv = null;
    var glGetVertexAttribiv: ?function_signatures.glGetVertexAttribiv = null;
    var glGetVertexAttribPointerv: ?function_signatures.glGetVertexAttribPointerv = null;
    var glIsProgram: ?function_signatures.glIsProgram = null;
    var glIsShader: ?function_signatures.glIsShader = null;
    var glLinkProgram: ?function_signatures.glLinkProgram = null;
    var glShaderSource: ?function_signatures.glShaderSource = null;
    var glUseProgram: ?function_signatures.glUseProgram = null;
    var glUniform1f: ?function_signatures.glUniform1f = null;
    var glUniform2f: ?function_signatures.glUniform2f = null;
    var glUniform3f: ?function_signatures.glUniform3f = null;
    var glUniform4f: ?function_signatures.glUniform4f = null;
    var glUniform1i: ?function_signatures.glUniform1i = null;
    var glUniform2i: ?function_signatures.glUniform2i = null;
    var glUniform3i: ?function_signatures.glUniform3i = null;
    var glUniform4i: ?function_signatures.glUniform4i = null;
    var glUniform1fv: ?function_signatures.glUniform1fv = null;
    var glUniform2fv: ?function_signatures.glUniform2fv = null;
    var glUniform3fv: ?function_signatures.glUniform3fv = null;
    var glUniform4fv: ?function_signatures.glUniform4fv = null;
    var glUniform1iv: ?function_signatures.glUniform1iv = null;
    var glUniform2iv: ?function_signatures.glUniform2iv = null;
    var glUniform3iv: ?function_signatures.glUniform3iv = null;
    var glUniform4iv: ?function_signatures.glUniform4iv = null;
    var glUniformMatrix2fv: ?function_signatures.glUniformMatrix2fv = null;
    var glUniformMatrix3fv: ?function_signatures.glUniformMatrix3fv = null;
    var glUniformMatrix4fv: ?function_signatures.glUniformMatrix4fv = null;
    var glValidateProgram: ?function_signatures.glValidateProgram = null;
    var glVertexAttrib1d: ?function_signatures.glVertexAttrib1d = null;
    var glVertexAttrib1dv: ?function_signatures.glVertexAttrib1dv = null;
    var glVertexAttrib1f: ?function_signatures.glVertexAttrib1f = null;
    var glVertexAttrib1fv: ?function_signatures.glVertexAttrib1fv = null;
    var glVertexAttrib1s: ?function_signatures.glVertexAttrib1s = null;
    var glVertexAttrib1sv: ?function_signatures.glVertexAttrib1sv = null;
    var glVertexAttrib2d: ?function_signatures.glVertexAttrib2d = null;
    var glVertexAttrib2dv: ?function_signatures.glVertexAttrib2dv = null;
    var glVertexAttrib2f: ?function_signatures.glVertexAttrib2f = null;
    var glVertexAttrib2fv: ?function_signatures.glVertexAttrib2fv = null;
    var glVertexAttrib2s: ?function_signatures.glVertexAttrib2s = null;
    var glVertexAttrib2sv: ?function_signatures.glVertexAttrib2sv = null;
    var glVertexAttrib3d: ?function_signatures.glVertexAttrib3d = null;
    var glVertexAttrib3dv: ?function_signatures.glVertexAttrib3dv = null;
    var glVertexAttrib3f: ?function_signatures.glVertexAttrib3f = null;
    var glVertexAttrib3fv: ?function_signatures.glVertexAttrib3fv = null;
    var glVertexAttrib3s: ?function_signatures.glVertexAttrib3s = null;
    var glVertexAttrib3sv: ?function_signatures.glVertexAttrib3sv = null;
    var glVertexAttrib4Nbv: ?function_signatures.glVertexAttrib4Nbv = null;
    var glVertexAttrib4Niv: ?function_signatures.glVertexAttrib4Niv = null;
    var glVertexAttrib4Nsv: ?function_signatures.glVertexAttrib4Nsv = null;
    var glVertexAttrib4Nub: ?function_signatures.glVertexAttrib4Nub = null;
    var glVertexAttrib4Nubv: ?function_signatures.glVertexAttrib4Nubv = null;
    var glVertexAttrib4Nuiv: ?function_signatures.glVertexAttrib4Nuiv = null;
    var glVertexAttrib4Nusv: ?function_signatures.glVertexAttrib4Nusv = null;
    var glVertexAttrib4bv: ?function_signatures.glVertexAttrib4bv = null;
    var glVertexAttrib4d: ?function_signatures.glVertexAttrib4d = null;
    var glVertexAttrib4dv: ?function_signatures.glVertexAttrib4dv = null;
    var glVertexAttrib4f: ?function_signatures.glVertexAttrib4f = null;
    var glVertexAttrib4fv: ?function_signatures.glVertexAttrib4fv = null;
    var glVertexAttrib4iv: ?function_signatures.glVertexAttrib4iv = null;
    var glVertexAttrib4s: ?function_signatures.glVertexAttrib4s = null;
    var glVertexAttrib4sv: ?function_signatures.glVertexAttrib4sv = null;
    var glVertexAttrib4ubv: ?function_signatures.glVertexAttrib4ubv = null;
    var glVertexAttrib4uiv: ?function_signatures.glVertexAttrib4uiv = null;
    var glVertexAttrib4usv: ?function_signatures.glVertexAttrib4usv = null;
    var glVertexAttribPointer: ?function_signatures.glVertexAttribPointer = null;
    var glUniformMatrix2x3fv: ?function_signatures.glUniformMatrix2x3fv = null;
    var glUniformMatrix3x2fv: ?function_signatures.glUniformMatrix3x2fv = null;
    var glUniformMatrix2x4fv: ?function_signatures.glUniformMatrix2x4fv = null;
    var glUniformMatrix4x2fv: ?function_signatures.glUniformMatrix4x2fv = null;
    var glUniformMatrix3x4fv: ?function_signatures.glUniformMatrix3x4fv = null;
    var glUniformMatrix4x3fv: ?function_signatures.glUniformMatrix4x3fv = null;
    var glColorMaski: ?function_signatures.glColorMaski = null;
    var glGetBooleani_v: ?function_signatures.glGetBooleani_v = null;
    var glGetIntegeri_v: ?function_signatures.glGetIntegeri_v = null;
    var glEnablei: ?function_signatures.glEnablei = null;
    var glDisablei: ?function_signatures.glDisablei = null;
    var glIsEnabledi: ?function_signatures.glIsEnabledi = null;
    var glBeginTransformFeedback: ?function_signatures.glBeginTransformFeedback = null;
    var glEndTransformFeedback: ?function_signatures.glEndTransformFeedback = null;
    var glBindBufferRange: ?function_signatures.glBindBufferRange = null;
    var glBindBufferBase: ?function_signatures.glBindBufferBase = null;
    var glTransformFeedbackVaryings: ?function_signatures.glTransformFeedbackVaryings = null;
    var glGetTransformFeedbackVarying: ?function_signatures.glGetTransformFeedbackVarying = null;
    var glClampColor: ?function_signatures.glClampColor = null;
    var glBeginConditionalRender: ?function_signatures.glBeginConditionalRender = null;
    var glEndConditionalRender: ?function_signatures.glEndConditionalRender = null;
    var glVertexAttribIPointer: ?function_signatures.glVertexAttribIPointer = null;
    var glGetVertexAttribIiv: ?function_signatures.glGetVertexAttribIiv = null;
    var glGetVertexAttribIuiv: ?function_signatures.glGetVertexAttribIuiv = null;
    var glVertexAttribI1i: ?function_signatures.glVertexAttribI1i = null;
    var glVertexAttribI2i: ?function_signatures.glVertexAttribI2i = null;
    var glVertexAttribI3i: ?function_signatures.glVertexAttribI3i = null;
    var glVertexAttribI4i: ?function_signatures.glVertexAttribI4i = null;
    var glVertexAttribI1ui: ?function_signatures.glVertexAttribI1ui = null;
    var glVertexAttribI2ui: ?function_signatures.glVertexAttribI2ui = null;
    var glVertexAttribI3ui: ?function_signatures.glVertexAttribI3ui = null;
    var glVertexAttribI4ui: ?function_signatures.glVertexAttribI4ui = null;
    var glVertexAttribI1iv: ?function_signatures.glVertexAttribI1iv = null;
    var glVertexAttribI2iv: ?function_signatures.glVertexAttribI2iv = null;
    var glVertexAttribI3iv: ?function_signatures.glVertexAttribI3iv = null;
    var glVertexAttribI4iv: ?function_signatures.glVertexAttribI4iv = null;
    var glVertexAttribI1uiv: ?function_signatures.glVertexAttribI1uiv = null;
    var glVertexAttribI2uiv: ?function_signatures.glVertexAttribI2uiv = null;
    var glVertexAttribI3uiv: ?function_signatures.glVertexAttribI3uiv = null;
    var glVertexAttribI4uiv: ?function_signatures.glVertexAttribI4uiv = null;
    var glVertexAttribI4bv: ?function_signatures.glVertexAttribI4bv = null;
    var glVertexAttribI4sv: ?function_signatures.glVertexAttribI4sv = null;
    var glVertexAttribI4ubv: ?function_signatures.glVertexAttribI4ubv = null;
    var glVertexAttribI4usv: ?function_signatures.glVertexAttribI4usv = null;
    var glGetUniformuiv: ?function_signatures.glGetUniformuiv = null;
    var glBindFragDataLocation: ?function_signatures.glBindFragDataLocation = null;
    var glGetFragDataLocation: ?function_signatures.glGetFragDataLocation = null;
    var glUniform1ui: ?function_signatures.glUniform1ui = null;
    var glUniform2ui: ?function_signatures.glUniform2ui = null;
    var glUniform3ui: ?function_signatures.glUniform3ui = null;
    var glUniform4ui: ?function_signatures.glUniform4ui = null;
    var glUniform1uiv: ?function_signatures.glUniform1uiv = null;
    var glUniform2uiv: ?function_signatures.glUniform2uiv = null;
    var glUniform3uiv: ?function_signatures.glUniform3uiv = null;
    var glUniform4uiv: ?function_signatures.glUniform4uiv = null;
    var glTexParameterIiv: ?function_signatures.glTexParameterIiv = null;
    var glTexParameterIuiv: ?function_signatures.glTexParameterIuiv = null;
    var glGetTexParameterIiv: ?function_signatures.glGetTexParameterIiv = null;
    var glGetTexParameterIuiv: ?function_signatures.glGetTexParameterIuiv = null;
    var glClearBufferiv: ?function_signatures.glClearBufferiv = null;
    var glClearBufferuiv: ?function_signatures.glClearBufferuiv = null;
    var glClearBufferfv: ?function_signatures.glClearBufferfv = null;
    var glClearBufferfi: ?function_signatures.glClearBufferfi = null;
    var glGetStringi: ?function_signatures.glGetStringi = null;
    var glIsRenderbuffer: ?function_signatures.glIsRenderbuffer = null;
    var glBindRenderbuffer: ?function_signatures.glBindRenderbuffer = null;
    var glDeleteRenderbuffers: ?function_signatures.glDeleteRenderbuffers = null;
    var glGenRenderbuffers: ?function_signatures.glGenRenderbuffers = null;
    var glRenderbufferStorage: ?function_signatures.glRenderbufferStorage = null;
    var glGetRenderbufferParameteriv: ?function_signatures.glGetRenderbufferParameteriv = null;
    var glIsFramebuffer: ?function_signatures.glIsFramebuffer = null;
    var glBindFramebuffer: ?function_signatures.glBindFramebuffer = null;
    var glDeleteFramebuffers: ?function_signatures.glDeleteFramebuffers = null;
    var glGenFramebuffers: ?function_signatures.glGenFramebuffers = null;
    var glCheckFramebufferStatus: ?function_signatures.glCheckFramebufferStatus = null;
    var glFramebufferTexture1D: ?function_signatures.glFramebufferTexture1D = null;
    var glFramebufferTexture2D: ?function_signatures.glFramebufferTexture2D = null;
    var glFramebufferTexture3D: ?function_signatures.glFramebufferTexture3D = null;
    var glFramebufferRenderbuffer: ?function_signatures.glFramebufferRenderbuffer = null;
    var glGetFramebufferAttachmentParameteriv: ?function_signatures.glGetFramebufferAttachmentParameteriv = null;
    var glGenerateMipmap: ?function_signatures.glGenerateMipmap = null;
    var glBlitFramebuffer: ?function_signatures.glBlitFramebuffer = null;
    var glRenderbufferStorageMultisample: ?function_signatures.glRenderbufferStorageMultisample = null;
    var glFramebufferTextureLayer: ?function_signatures.glFramebufferTextureLayer = null;
    var glMapBufferRange: ?function_signatures.glMapBufferRange = null;
    var glFlushMappedBufferRange: ?function_signatures.glFlushMappedBufferRange = null;
    var glBindVertexArray: ?function_signatures.glBindVertexArray = null;
    var glDeleteVertexArrays: ?function_signatures.glDeleteVertexArrays = null;
    var glGenVertexArrays: ?function_signatures.glGenVertexArrays = null;
    var glIsVertexArray: ?function_signatures.glIsVertexArray = null;
    var glDrawArraysInstanced: ?function_signatures.glDrawArraysInstanced = null;
    var glDrawElementsInstanced: ?function_signatures.glDrawElementsInstanced = null;
    var glTexBuffer: ?function_signatures.glTexBuffer = null;
    var glPrimitiveRestartIndex: ?function_signatures.glPrimitiveRestartIndex = null;
    var glCopyBufferSubData: ?function_signatures.glCopyBufferSubData = null;
    var glGetUniformIndices: ?function_signatures.glGetUniformIndices = null;
    var glGetActiveUniformsiv: ?function_signatures.glGetActiveUniformsiv = null;
    var glGetActiveUniformName: ?function_signatures.glGetActiveUniformName = null;
    var glGetUniformBlockIndex: ?function_signatures.glGetUniformBlockIndex = null;
    var glGetActiveUniformBlockiv: ?function_signatures.glGetActiveUniformBlockiv = null;
    var glGetActiveUniformBlockName: ?function_signatures.glGetActiveUniformBlockName = null;
    var glUniformBlockBinding: ?function_signatures.glUniformBlockBinding = null;
    var glCreateTransformFeedbacks: ?function_signatures.glCreateTransformFeedbacks = null;
    var glTransformFeedbackBufferBase: ?function_signatures.glTransformFeedbackBufferBase = null;
    var glTransformFeedbackBufferRange: ?function_signatures.glTransformFeedbackBufferRange = null;
    var glGetTransformFeedbackiv: ?function_signatures.glGetTransformFeedbackiv = null;
    var glGetTransformFeedbacki_v: ?function_signatures.glGetTransformFeedbacki_v = null;
    var glGetTransformFeedbacki64_v: ?function_signatures.glGetTransformFeedbacki64_v = null;
    var glCreateBuffers: ?function_signatures.glCreateBuffers = null;
    var glNamedBufferStorage: ?function_signatures.glNamedBufferStorage = null;
    var glNamedBufferData: ?function_signatures.glNamedBufferData = null;
    var glNamedBufferSubData: ?function_signatures.glNamedBufferSubData = null;
    var glCopyNamedBufferSubData: ?function_signatures.glCopyNamedBufferSubData = null;
    var glClearNamedBufferData: ?function_signatures.glClearNamedBufferData = null;
    var glClearNamedBufferSubData: ?function_signatures.glClearNamedBufferSubData = null;
    var glMapNamedBuffer: ?function_signatures.glMapNamedBuffer = null;
    var glMapNamedBufferRange: ?function_signatures.glMapNamedBufferRange = null;
    var glUnmapNamedBuffer: ?function_signatures.glUnmapNamedBuffer = null;
    var glFlushMappedNamedBufferRange: ?function_signatures.glFlushMappedNamedBufferRange = null;
    var glGetNamedBufferParameteriv: ?function_signatures.glGetNamedBufferParameteriv = null;
    var glGetNamedBufferParameteri64v: ?function_signatures.glGetNamedBufferParameteri64v = null;
    var glGetNamedBufferPointerv: ?function_signatures.glGetNamedBufferPointerv = null;
    var glGetNamedBufferSubData: ?function_signatures.glGetNamedBufferSubData = null;
    var glCreateFramebuffers: ?function_signatures.glCreateFramebuffers = null;
    var glNamedFramebufferRenderbuffer: ?function_signatures.glNamedFramebufferRenderbuffer = null;
    var glNamedFramebufferParameteri: ?function_signatures.glNamedFramebufferParameteri = null;
    var glNamedFramebufferTexture: ?function_signatures.glNamedFramebufferTexture = null;
    var glNamedFramebufferTextureLayer: ?function_signatures.glNamedFramebufferTextureLayer = null;
    var glNamedFramebufferDrawBuffer: ?function_signatures.glNamedFramebufferDrawBuffer = null;
    var glNamedFramebufferDrawBuffers: ?function_signatures.glNamedFramebufferDrawBuffers = null;
    var glNamedFramebufferReadBuffer: ?function_signatures.glNamedFramebufferReadBuffer = null;
    var glInvalidateNamedFramebufferData: ?function_signatures.glInvalidateNamedFramebufferData = null;
    var glInvalidateNamedFramebufferSubData: ?function_signatures.glInvalidateNamedFramebufferSubData = null;
    var glClearNamedFramebufferiv: ?function_signatures.glClearNamedFramebufferiv = null;
    var glClearNamedFramebufferuiv: ?function_signatures.glClearNamedFramebufferuiv = null;
    var glClearNamedFramebufferfv: ?function_signatures.glClearNamedFramebufferfv = null;
    var glClearNamedFramebufferfi: ?function_signatures.glClearNamedFramebufferfi = null;
    var glBlitNamedFramebuffer: ?function_signatures.glBlitNamedFramebuffer = null;
    var glCheckNamedFramebufferStatus: ?function_signatures.glCheckNamedFramebufferStatus = null;
    var glGetNamedFramebufferParameteriv: ?function_signatures.glGetNamedFramebufferParameteriv = null;
    var glGetNamedFramebufferAttachmentParameteriv: ?function_signatures.glGetNamedFramebufferAttachmentParameteriv = null;
    var glCreateRenderbuffers: ?function_signatures.glCreateRenderbuffers = null;
    var glNamedRenderbufferStorage: ?function_signatures.glNamedRenderbufferStorage = null;
    var glNamedRenderbufferStorageMultisample: ?function_signatures.glNamedRenderbufferStorageMultisample = null;
    var glGetNamedRenderbufferParameteriv: ?function_signatures.glGetNamedRenderbufferParameteriv = null;
    var glCreateTextures: ?function_signatures.glCreateTextures = null;
    var glTextureBuffer: ?function_signatures.glTextureBuffer = null;
    var glTextureBufferRange: ?function_signatures.glTextureBufferRange = null;
    var glTextureStorage1D: ?function_signatures.glTextureStorage1D = null;
    var glTextureStorage2D: ?function_signatures.glTextureStorage2D = null;
    var glTextureStorage3D: ?function_signatures.glTextureStorage3D = null;
    var glTextureStorage2DMultisample: ?function_signatures.glTextureStorage2DMultisample = null;
    var glTextureStorage3DMultisample: ?function_signatures.glTextureStorage3DMultisample = null;
    var glTextureSubImage1D: ?function_signatures.glTextureSubImage1D = null;
    var glTextureSubImage2D: ?function_signatures.glTextureSubImage2D = null;
    var glTextureSubImage3D: ?function_signatures.glTextureSubImage3D = null;
    var glCompressedTextureSubImage1D: ?function_signatures.glCompressedTextureSubImage1D = null;
    var glCompressedTextureSubImage2D: ?function_signatures.glCompressedTextureSubImage2D = null;
    var glCompressedTextureSubImage3D: ?function_signatures.glCompressedTextureSubImage3D = null;
    var glCopyTextureSubImage1D: ?function_signatures.glCopyTextureSubImage1D = null;
    var glCopyTextureSubImage2D: ?function_signatures.glCopyTextureSubImage2D = null;
    var glCopyTextureSubImage3D: ?function_signatures.glCopyTextureSubImage3D = null;
    var glTextureParameterf: ?function_signatures.glTextureParameterf = null;
    var glTextureParameterfv: ?function_signatures.glTextureParameterfv = null;
    var glTextureParameteri: ?function_signatures.glTextureParameteri = null;
    var glTextureParameterIiv: ?function_signatures.glTextureParameterIiv = null;
    var glTextureParameterIuiv: ?function_signatures.glTextureParameterIuiv = null;
    var glTextureParameteriv: ?function_signatures.glTextureParameteriv = null;
    var glGenerateTextureMipmap: ?function_signatures.glGenerateTextureMipmap = null;
    var glBindTextureUnit: ?function_signatures.glBindTextureUnit = null;
    var glGetTextureImage: ?function_signatures.glGetTextureImage = null;
    var glGetCompressedTextureImage: ?function_signatures.glGetCompressedTextureImage = null;
    var glGetTextureLevelParameterfv: ?function_signatures.glGetTextureLevelParameterfv = null;
    var glGetTextureLevelParameteriv: ?function_signatures.glGetTextureLevelParameteriv = null;
    var glGetTextureParameterfv: ?function_signatures.glGetTextureParameterfv = null;
    var glGetTextureParameterIiv: ?function_signatures.glGetTextureParameterIiv = null;
    var glGetTextureParameterIuiv: ?function_signatures.glGetTextureParameterIuiv = null;
    var glGetTextureParameteriv: ?function_signatures.glGetTextureParameteriv = null;
    var glCreateVertexArrays: ?function_signatures.glCreateVertexArrays = null;
    var glDisableVertexArrayAttrib: ?function_signatures.glDisableVertexArrayAttrib = null;
    var glEnableVertexArrayAttrib: ?function_signatures.glEnableVertexArrayAttrib = null;
    var glVertexArrayElementBuffer: ?function_signatures.glVertexArrayElementBuffer = null;
    var glVertexArrayVertexBuffer: ?function_signatures.glVertexArrayVertexBuffer = null;
    var glVertexArrayVertexBuffers: ?function_signatures.glVertexArrayVertexBuffers = null;
    var glVertexArrayAttribBinding: ?function_signatures.glVertexArrayAttribBinding = null;
    var glVertexArrayAttribFormat: ?function_signatures.glVertexArrayAttribFormat = null;
    var glVertexArrayAttribIFormat: ?function_signatures.glVertexArrayAttribIFormat = null;
    var glVertexArrayAttribLFormat: ?function_signatures.glVertexArrayAttribLFormat = null;
    var glVertexArrayBindingDivisor: ?function_signatures.glVertexArrayBindingDivisor = null;
    var glGetVertexArrayiv: ?function_signatures.glGetVertexArrayiv = null;
    var glGetVertexArrayIndexediv: ?function_signatures.glGetVertexArrayIndexediv = null;
    var glGetVertexArrayIndexed64iv: ?function_signatures.glGetVertexArrayIndexed64iv = null;
    var glCreateSamplers: ?function_signatures.glCreateSamplers = null;
    var glCreateProgramPipelines: ?function_signatures.glCreateProgramPipelines = null;
    var glCreateQueries: ?function_signatures.glCreateQueries = null;
    var glGetQueryBufferObjecti64v: ?function_signatures.glGetQueryBufferObjecti64v = null;
    var glGetQueryBufferObjectiv: ?function_signatures.glGetQueryBufferObjectiv = null;
    var glGetQueryBufferObjectui64v: ?function_signatures.glGetQueryBufferObjectui64v = null;
    var glGetQueryBufferObjectuiv: ?function_signatures.glGetQueryBufferObjectuiv = null;
};

test "" {
    _ = load;
}
