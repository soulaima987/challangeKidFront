import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";
import { ChartsComponent } from "./charts/charts.component";
import { FeedsComponent } from "./feeds/feeds.component";
import { ListsComponent } from "./lists/lists.component";
import { MixedComponent } from "./mixed/mixed.component";
import { StatisticsComponent } from "./statistics/statistics.component";
import { TablesComponent } from "./tables/tables.component";
import { WidgetsExamplesComponent } from "./widgets-examples.component";
import { CategoryComponent } from "./category/category.component";
import { ChallengeComponent } from "./challenge/challenge.component";
import { CoachComponent } from "./coach/coach.component";
import { PostComponent } from "./post/post.component";
import { ChapterComponent } from "./chapter/chapter.component";
import { LessonComponent } from "./lesson/lesson.component";
import { KidComponent } from "./kid/kid.component";
import { CoachesPostsComponent } from "./coaches-posts/coaches-posts.component";
import { CoachLessonComponent } from "./coach-lesson/coach-lesson.component";
import { CoachChapterComponent } from "./coach-chapter/coach-chapter.component";
import { CoachchallengeComponent } from "./coachchallenge/coachchallenge.component";
import { ViewChallengeComponent } from "./view-challenge/view-challenge.component";
import { ViewChapterComponent } from "./view-chapter/view-chapter.component";
import { ViewLessonComponent } from "./view-lesson/view-lesson.component";
import { SubmissionsComponent } from "./submissions/submissions.component";
import { ViewpostComponent } from "./viewpost/viewpost.component";

const routes: Routes = [
  {
    path: "",
    component: WidgetsExamplesComponent,
    children: [
      { path: "submissions", component: SubmissionsComponent },
      { path: "coachesposts", component: CoachesPostsComponent },
      { path: "coachLessons", component: CoachLessonComponent },
      {
        path: "lists",
        component: ListsComponent,
      },
      {
        path: "coachchapters",
        component: CoachChapterComponent,
      },
      {
        path: "coachchallenges",
        component: CoachchallengeComponent,
      },
      {
        path: "viewchallenge/:id",
        component: ViewChallengeComponent,
      },
      {
        path: "viewlesson/:id",
        component: ViewLessonComponent,
      },
      {
        path: "viewpost/:id",
        component: ViewpostComponent,
      },
      {
        path: "viewchapter/:id",
        component: ViewChapterComponent,
      },
      {
        path: "kids",
        component: KidComponent,
      },
      {
        path: "lessons",
        component: LessonComponent,
      },
      {
        path: "chapters",
        component: ChapterComponent,
      },
      {
        path: "posts",
        component: PostComponent,
      },
      {
        path: "challenges",
        component: ChallengeComponent,
      },
      {
        path: "category",
        component: CategoryComponent,
      },
      {
        path: "statistics",
        component: StatisticsComponent,
      },
      {
        path: "charts",
        component: ChartsComponent,
      },
      {
        path: "mixed",
        component: MixedComponent,
      },
      {
        path: "tables",
        component: TablesComponent,
      },
      {
        path: "feeds",
        component: FeedsComponent,
      },
      {
        path: "coach",
        component: CoachComponent,
      },
      { path: "", redirectTo: "lists", pathMatch: "full" },
      { path: "**", redirectTo: "lists", pathMatch: "full" },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class WidgetsExamplesRoutingModule {}
