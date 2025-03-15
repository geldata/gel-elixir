CREATE MIGRATION m1jsxcohxbbadwjxasxq37ekaf2be65zgdhpsf5zxte6rnqvtqkzhq
    ONTO m1x3caw2bvjawobvubfxeuhyz2fafivcdikn6fhf2dwcbgsamgkkba
{
  ALTER TYPE v6::codegen::MultiRangeInt32PropertiesType {
      ALTER PROPERTY rp_multi_range_int32 {
          RENAME TO rp_multirange_int32;
      };
  };
  ALTER TYPE v6::codegen::MultiRangeInt64PropertiesType {
      ALTER PROPERTY rp_multi_range_int64 {
          RENAME TO rp_multirange_int64;
      };
  };
};
