CREATE MIGRATION m1x3caw2bvjawobvubfxeuhyz2fafivcdikn6fhf2dwcbgsamgkkba
    ONTO m1idwmhxpsv2pamu6jm2fv5wipu7ef5str3nil4buejdn2bdyh4lvq
{
  ALTER TYPE v6::codegen::VectorPropertiesType {
      DROP PROPERTY mp_vector_type;
  };
  ALTER TYPE v6::codegen::VectorPropertiesType {
      DROP PROPERTY op_vector_type;
  };
  ALTER TYPE v6::codegen::VectorPropertiesType {
      DROP PROPERTY rp_vector_type;
  };
  DROP SCALAR TYPE v6::codegen::VectorType;
  CREATE SCALAR TYPE v6::codegen::VectorType EXTENDING ext::pgvector::vector<3>;
  ALTER TYPE v6::codegen::VectorPropertiesType {
      CREATE MULTI PROPERTY mp_vector_type: v6::codegen::VectorType;
  };
  ALTER TYPE v6::codegen::VectorPropertiesType {
      CREATE PROPERTY op_vector_type: v6::codegen::VectorType;
  };
  ALTER TYPE v6::codegen::VectorPropertiesType {
      CREATE REQUIRED PROPERTY rp_vector_type: v6::codegen::VectorType {
          SET REQUIRED USING (<v6::codegen::VectorType>[1.5, 2.0, 4.5]);
      };
  };
};
