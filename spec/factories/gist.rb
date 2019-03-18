FactoryGirl.define do
  factory :file1 , class: GistFile do
    filename {"file1.txt"}
    content {"file 1 content "}
  end

  factory :file2 , class: GistFile do
    filename {"file2.txt"}
    content {"file 2 content "}
  end

  factory :file3 , class: GistFile do
    filename {"file3.txt"}
    content {"file 3 content "}
  end

  factory :invalid_file , class: GistFile do
    content {"file 3 content "}
  end

  factory :gist1, class: Gist do
    description {"Gist 1 description"}
    files {[FactoryGirl.build(:file1),FactoryGirl.build(:file2)]}
  end

  factory :gist2, class: Gist do
    description {"Gist 1 description"}
    files {[FactoryGirl.build(:file2)]}
  end

  factory :gist3, class: Gist do
    description {"Gist 1 description"}
    files {[FactoryGirl.build(:file3)]}
  end

  factory :single_file_gist, class: Gist do
    description {"Gist 1 description"}
    files {[FactoryGirl.build(:file1)]}
  end

  factory :invalid_file_gist, class: Gist do
    description {"Invalid file Gist"}
    files {[FactoryGirl.build(:invalid_file)]}
  end
  
end