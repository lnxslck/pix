var Query = {

    allPics : "select * from images order by strftime(\"%s\", addDate) desc",
    picLikeUrl_ : "select * from images where url like \"%1%\" "
}
